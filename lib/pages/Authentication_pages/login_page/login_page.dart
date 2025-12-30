import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/auth_controller.dart';

// Amazing Login Page
class LoginPage extends StatefulWidget {
  final PageController pageController;
  static const pageName = 'Login Page';
  final Animation<double> pageAnimation;

  const LoginPage({
    super.key,
    required this.pageAnimation,
    required this.pageController,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _formController;
  late AnimationController _logoController;
  late Animation<double> _formAnimation;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _slideAnimation;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );

    // Start animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: Listenable.merge([_formAnimation, _logoAnimation]),
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(height: size.height * 0.1),

              // Animated Logo
              Transform.scale(
                scale: _logoAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 50,
                    color: Color(0xFF6B73FF),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Welcome Text
              SlideTransition(
                position: _slideAnimation,
                child: Opacity(
                  opacity: _formAnimation.value.clamp(0.0, 1.0),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue cooking amazing recipes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Login Form
              SlideTransition(
                position: _slideAnimation,
                child: Opacity(
                  opacity: _formAnimation.value,
                  child: Form(
                    key: authController.loginFormKey,
                    child: Column(
                      children: [
                        // Email Field - NO Obx needed (no reactive variables)
                        _buildAnimatedTextField(
                          controller: authController.emailController,
                          hintText: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: authController.validateEmail,
                        ),

                        const SizedBox(height: 20),

                        // Password Field - Obx needed for obscurePassword
                        _buildAnimatedTextField(
                          controller: authController.passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: authController.validatePassword,
                        ),

                        const SizedBox(height: 20),

                        // Remember Me & Forgot Password - Obx needed for rememberMe
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: authController.rememberMe.value,
                                      onChanged: authController.toggleRememberMe,
                                      activeColor: Colors.white,
                                      checkColor: const Color(0xFF6B73FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: authController.forgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Login Button - Obx needed for isLoading
                        _buildAnimatedButton(
                          text: 'Sign In',
                        ),

                        const SizedBox(height: 30),

                        // Social Login - Obx needed for loading states
                        _buildSocialLoginSection(),

                        const SizedBox(height: 30),

                        // Sign Up Link
                        TextButton(
                          onPressed: () {
                            widget.pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Obx(
        () => TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? authController.obscurePassword.value : false,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      authController.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                    onPressed: authController.togglePasswordVisibility,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
  }) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF0F0F0)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: authController.isLoading.value
                ? null
                : authController.login,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: authController.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6B73FF),
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B73FF),
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(height: 1, color: Colors.white.withOpacity(0.3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(height: 1, color: Colors.white.withOpacity(0.3)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => _buildSocialButton(
                label: "Google",
                icon: authController.isGoogleLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login, color: Colors.white),
                onPressed: authController.isGoogleLoading.value
                    ? null
                    : authController.signInWithGoogle,
              ),
            ),
            Obx(
              () => _buildSocialButton(
                label: "Github",
                icon: authController.isGitHubLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.code, color: Colors.white),
                onPressed: authController.isGitHubLoading.value
                    ? null
                    : authController.signInWithGitHub,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required Future<void> Function()? onPressed,
  }) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}