import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:recipe_book/pages/Authentication_pages/login_page/login_page.dart';
import 'package:recipe_book/pages/Authentication_pages/sign_up_page/sign_up_page.dart';

class AuthenticationPage extends StatefulWidget {
  static const pageAdress = '/auth';
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pageController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _pageAnimation;

  final PageController _pageViewController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _pageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeInOutCubic),
    );

    _backgroundController.repeat();
    _pageController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pageController.dispose();
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFF6B73FF),
                  Color(0xFF9B59B6),
                  Color(0xFFFF6B6B),
                ],
                stops: [
                  0.3 +
                      math.sin(_backgroundAnimation.value * 2 * math.pi) * 0.1,
                  0.6,
                  0.9 +
                      math.cos(_backgroundAnimation.value * 2 * math.pi) * 0.1,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated Background Particles
                ..._buildBackgroundParticles(),

                // Main Content
                SafeArea(
                  child: PageView(
                    controller: _pageViewController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      LoginPage(
                        pageAnimation: _pageAnimation,
                        pageController: _pageViewController,
                      ),
                      SignUpPage(
                        pageAnimation: _pageAnimation,
                        pageController: _pageViewController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildBackgroundParticles() {
    final particles = <Widget>[];
    final size = MediaQuery.sizeOf(context);

    for (int i = 0; i < 20; i++) {
      final random = math.Random(i);
      particles.add(
        AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            final progress =
                (_backgroundAnimation.value + random.nextDouble()) % 1.0;
            final x = random.nextDouble() * size.width;
            final y = size.height * progress;
            final opacity = math.sin(progress * math.pi * 2) * 0.3;

            return Positioned(
              left: x + math.sin(progress * 4 * math.pi) * 50,
              top: y,
              child: Opacity(
                opacity: opacity.abs(),
                child: Container(
                  width: 2 + random.nextDouble() * 4,
                  height: 2 + random.nextDouble() * 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
