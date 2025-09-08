import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Controller/async_suggestions_controller.dart';

class EnhancedSearchBarWidget extends StatefulWidget {
  const EnhancedSearchBarWidget({super.key});

  @override
  State<EnhancedSearchBarWidget> createState() =>
      _EnhancedSearchBarWidgetState();
}

class _EnhancedSearchBarWidgetState extends State<EnhancedSearchBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _searchAnimation;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _searchBarKey = GlobalKey();

  bool _isSearching = false;
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;

  final homePageController = Get.find<HomePageController>();
  late final AsyncSuggestionsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AsyncSuggestionsController());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: -10.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _focusNode.addListener(_onFocusChange);
    _animationController.forward();
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    _searchAnimationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isSearching = true;
      });
      _searchAnimationController.forward();
      if (_textController.text.isNotEmpty) {
        _showSuggestionsOverlay();
      }
    } else {
      setState(() {
        _isSearching = false;
      });
      _searchAnimationController.reverse();
      _removeOverlay();
    }
  }

  Future<void> _fetchRecipeSuggestions(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    controller.isLoading.value = true;

    try {
      final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
      final response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'] ?? [];

        List<String> mealNames =
            meals.map<String>((meal) => meal['strMeal'] as String).toList();

        controller.updateSuggestions(
          mealNames.take(8).toList(),
        ); // Limit to 8 suggestions
        controller.isLoading.value = false;

        if (mealNames.isNotEmpty && _focusNode.hasFocus) {
          _showSuggestionsOverlay();
        } else {
          _removeOverlay();
        }
      } else {
        controller.isLoading.value = false;
        _removeOverlay();
      }
    } catch (e) {
      controller.isLoading.value = false;
      _removeOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();

    final RenderBox renderBox =
        _searchBarKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 8,
            width: size.width,
            child: _SuggestionsOverlay(
              controller: controller,
              onSuggestionTap: (suggestion) {
                _textController.text = suggestion;
                _focusNode.unfocus();
                homePageController.onSuggestionTap(suggestion);
                _removeOverlay();
              },
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _focusNode.unfocus();
      homePageController.onSuggestionTap(query);
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              key: _searchBarKey,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, child) {
                  return Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            _isSearching
                                ? const Color(0xFF6B73FF).withOpacity(0.3)
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Search Icon with Animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.search,
                            color:
                                _isSearching
                                    ? const Color(0xFF6B73FF)
                                    : Colors.grey[400],
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Search TextField
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            onChanged: _fetchRecipeSuggestions,
                            onSubmitted: _onSearchSubmitted,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2D3748),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  _isSearching
                                      ? 'Search for recipes...'
                                      : 'Try "Lamb Biryani"',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // Action Buttons
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              _textController.text.isNotEmpty
                                  ? GestureDetector(
                                    onTap: () {
                                      _textController.clear();
                                      _removeOverlay();
                                      controller.suggestions.clear();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        if (_textController.text.isNotEmpty)
                          const SizedBox(width: 8),

                        // Loading Indicator
                        Obx(
                          () =>
                              controller.isLoading.value
                                  ? Container(
                                    width: 20,
                                    height: 20,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF6B73FF),
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionsOverlay extends StatelessWidget {
  final AsyncSuggestionsController controller;
  final Function(String) onSuggestionTap;

  const _SuggestionsOverlay({
    required this.controller,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = controller.suggestions[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 200 + (index * 50)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, animValue, child) {
                          return Transform.translate(
                            offset: Offset(20 * (1 - animValue), 0),
                            child: Opacity(
                              opacity: animValue,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => onSuggestionTap(suggestion),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF6B73FF,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.restaurant,
                                            size: 16,
                                            color: Color(0xFF6B73FF),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            suggestion,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF2D3748),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.north_west,
                                          size: 16,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom AppBar that integrates with the search
class EnhancedHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EnhancedHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Title
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recipe Book',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            const EnhancedSearchBarWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
