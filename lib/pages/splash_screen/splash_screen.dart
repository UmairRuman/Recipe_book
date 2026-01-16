import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/pages/Authentication_pages/main_auth_page.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/view/home_page.dart';
import 'package:recipe_book/services/auth_services/auth_service.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';

class SplashScreen extends StatefulWidget {
  static const pageAdress = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _progressController;

  // Animations
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _progressAnimation;

  // UI State
  String _loadingText = "Preparing your recipes...";
  final List<String> _loadingMessages = [
    "Preparing your recipes...",
    "Mixing ingredients...",
    "Adding special spices...",
    "Almost ready to cook!",
  ];
  int _messageIndex = 0;
  bool _hasNavigated = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Rotation Animation for Logo
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Scale Animation for Logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Fade Animation for Background
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Slide Animation for Title
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Particle Animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Text Animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );
    _textSlideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Progress Animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

   void _startAnimationSequence() async {
    try {
      // Start background fade
      _fadeController.forward();

      // Delay then start logo animations
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      
      _scaleController.forward();
      _rotationController.repeat();

      // Start particle animation
      _particleController.repeat();

      // Delay then start title slide
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      
      _slideController.forward();

      // Start progress and text animations
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      
      _progressController.forward();
      _textController.forward();

      // Cycle through loading messages
      _cycleLoadingMessages();

      // Navigate after ALL animations complete (3.5 seconds total)
      await Future.delayed(const Duration(milliseconds: 3500));
      if (!mounted || _hasNavigated) return;
      
      await _navigateToNextScreen();
    } catch (e) {
      debugPrint('❌ Animation sequence error: $e');
      // Fallback navigation on error
      if (mounted && !_hasNavigated) {
        _navigateToNextScreen();
      }
    }
  }

  void _cycleLoadingMessages() async {
    try {
      for (int i = 1; i < _loadingMessages.length; i++) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted || _hasNavigated) return;
        
        setState(() {
          _messageIndex = i;
          _loadingText = _loadingMessages[i];
        });
        
        _textController.reset();
        _textController.forward();
      }
    } catch (e) {
      debugPrint('❌ Message cycle error: $e');
    }
  }

  // lib/pages/splash_screen/splash_screen.dart

Future<void> _navigateToNextScreen() async {
  if (_hasNavigated) {
    debugPrint('⚠️ Already navigated, skipping...');
    return;
  }

  _hasNavigated = true;
  debugPrint('🚀 Navigating from splash screen...');

  try {
    final authService = Get.find<AuthService>();
    final isAuthenticated = authService.isAuthenticated;

    debugPrint('🔐 Is Authenticated: $isAuthenticated');

    if (!mounted) return;

    // Check if app was launched from notification
    String? notificationPayload;
    try {
      notificationPayload = Get.find<String>(tag: 'notification_payload');
      debugPrint('📱 Found notification payload: $notificationPayload');
    } catch (e) {
      // No notification payload
    }

    // Navigate based on authentication and notification
    if (notificationPayload != null && isAuthenticated) {
      // App opened from notification and user is logged in
      debugPrint('✅ Navigating to Recipe from notification');
      
      // Add payload to stream for RecipePage
      final homeController = Get.find<HomePageController>();
      homeController.selectedNotificationStream.add(notificationPayload);
      
      // Navigate to recipe page
      await Get.offAllNamed(AppRoutes.recipe);
    } else if (isAuthenticated) {
      // Normal launch, user logged in
      debugPrint('✅ Navigating to Home');
      await Get.offAllNamed(AppRoutes.home);
    } else {
      // User not logged in
      debugPrint('✅ Navigating to Auth');
      await Get.offAllNamed(AppRoutes.auth);
    }
  } catch (e) {
    debugPrint('⚠️ Splash: Navigation error: $e');
    if (mounted) {
      await Get.offAllNamed(AppRoutes.auth);
    }
  }
}

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeAnimation,
          _scaleAnimation,
          _rotationAnimation,
          _slideAnimation,
          _particleAnimation,
          _textFadeAnimation,
          _textSlideAnimation,
          _progressAnimation,
        ]),
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B73FF).withOpacity(_fadeAnimation.value),
                  Color(0xFF9B59B6).withOpacity(_fadeAnimation.value),
                  Color(0xFFFF6B6B).withOpacity(_fadeAnimation.value),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated Particles Background
                ..._buildParticles(size),

                // Main Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value * 0.2,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 60,
                                  offset: const Offset(0, -10),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Transform.rotate(
                                    angle: -_rotationAnimation.value * 0.1,
                                    child: const Icon(
                                      Icons.restaurant_menu,
                                      size: 60,
                                      color: Color(0xFF6B73FF),
                                    ),
                                  ),
                                ),
                                // Glowing effect
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.0),
                                        Color(0xFF6B73FF).withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Animated Title
                      SlideTransition(
                        position: _slideAnimation,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: const Text(
                            'Recipe Book',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Animated Subtitle
                      SlideTransition(
                        position: _slideAnimation,
                        child: Opacity(
                          opacity: _fadeAnimation.value * 0.8,
                          child: const Text(
                            'Discover Amazing Recipes',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Animated Progress Bar
                      Container(
                        width: size.width * 0.7,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width:
                                (size.width * 0.7) * _progressAnimation.value,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.white, Colors.yellow],
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Animated Loading Text
                      Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Text(
                            _loadingText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Version or Brand Info (Bottom)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.7,
                    child: const Column(
                      children: [
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Made with ❤️ for Food Lovers',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    final particles = <Widget>[];

    for (int i = 0; i < 15; i++) {
      final random = math.Random(i);
      final startX = random.nextDouble() * size.width;
      final startY = size.height + 50;
      final endY = -50.0;
      final particleSize = 4.0 + random.nextDouble() * 6.0;
      final animationDelay = random.nextDouble() * 2.0;

      particles.add(
        AnimatedBuilder(
          animation: _particleAnimation,
          builder: (context, child) {
            final progress = (_particleAnimation.value + animationDelay) % 1.0;
            final currentY = startY + (endY - startY) * progress;
            final opacity = math.sin(progress * math.pi);

            return Positioned(
              left: startX + math.sin(progress * 4 * math.pi) * 30,
              top: currentY,
              child: Opacity(
                opacity: opacity * 0.6,
                child: Container(
                  width: particleSize,
                  height: particleSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(particleSize / 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return particles;
  }
}
