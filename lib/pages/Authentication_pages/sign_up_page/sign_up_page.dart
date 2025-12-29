// lib/pages/Authentication_pages/sign_up_page/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  static const pageAddress = '/signup';
  final PageController pageController;
  final Animation<double> pageAnimation;

  const SignUpPage({
    super.key,
    required this.pageAnimation,
    required this.pageController,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  late AnimationController _formController;
  late AnimationController _logoController;
  late AnimationController _stepController;
  late Animation<double> _formAnimation;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _stepAnimation;
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

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _stepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _stepController, curve: Curves.easeInOutCubic),
    );

    // Start animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _formController.forward();
      _stepController.forward();
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _logoController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _formAnimation,
          _logoAnimation,
          _stepAnimation,
        ]),
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(height: size.height * 0.08),

              // Animated Logo with Steps
              Transform.scale(
                scale: _logoAnimation.value,
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add,
                        size: 45,
                        color: Color(0xFF6B73FF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStepIndicator(),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Welcome Text
              SlideTransition(
                position: _slideAnimation,
                child: Opacity(
                  opacity: _formAnimation.value,
                  child: Column(
                    children: [
                      const Text(
                        'Join Recipe Book!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your account to start your culinary journey',
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

              const SizedBox(height: 40),

              // SignUp Form
              SlideTransition(
                position: _slideAnimation,
                child: Opacity(
                  opacity: _formAnimation.value,
                  child: Form(
                    key: authController.signupFormKey, // ✅ FIXED: Using controller's form key
                    child: Column(
                      children: [
                        // Full Name Field
                        _buildAnimatedTextField(
                          controller: authController.fullNameController,
                          validator: authController.validateFullName,
                          hintText: 'Full Name',
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                        ),

                        const SizedBox(height: 16),

                        // Email Field
                        _buildAnimatedTextField(
                          controller: authController.emailController,
                          validator: authController.validateEmail,
                          hintText: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        _buildAnimatedTextField(
                          controller: authController.passwordController,
                          validator: authController.validatePassword,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isConfirmPassword: false,
                        ),

                        const SizedBox(height: 16),

                        // Confirm Password Field
                        _buildAnimatedTextField(
                          controller: authController.confirmPasswordController,
                          validator: authController.validateConfirmPassword,
                          hintText: 'Confirm Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isConfirmPassword: true,
                        ),

                        const SizedBox(height: 20),

                        // Terms & Conditions
                        Obx(
                          () => Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: authController.acceptTerms.value,
                                  onChanged: authController.toggleAcceptTerms,
                                  activeColor: Colors.white,
                                  checkColor: const Color(0xFF6B73FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    authController.toggleAcceptTerms(
                                      !authController.acceptTerms.value,
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'Privacy Policy',
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
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // SignUp Button
                        _buildAnimatedButton(
                          text: 'Create Account',
                        ),

                        const SizedBox(height: 30),

                        // Login Link
                        TextButton(
                          onPressed: () {
                            widget.pageController.animateToPage(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Sign In',
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

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_add, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text(
            'Step 1 of 1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
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
          obscureText: isPassword
              ? (isConfirmPassword
                  ? authController.obscureConfirmPassword.value
                  : authController.obscurePassword.value)
              : false, // ✅ FIXED: Proper logic
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
                      isConfirmPassword
                          ? (authController.obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility)
                          : (authController.obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                    onPressed: isConfirmPassword
                        ? authController.toggleConfirmPasswordVisibility
                        : authController.togglePasswordVisibility,
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
                : authController.signUp, // ✅ FIXED: Direct call
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rocket_launch,
                          color: Color(0xFF6B73FF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B73FF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}