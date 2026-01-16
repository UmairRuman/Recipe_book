// lib/controllers/auth_controller.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/models/user_model.dart';
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/services/auth_services/auth_exceptions.dart';
import 'package:recipe_book/services/auth_services/auth_service.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';


/// Authentication controller managing all authentication UI logic
class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final _authService = AuthService.instance;
  final _secureStorage = SecureStorageService.instance;

  // ==================== Reactive Variables ====================
  
  // Loading states
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isGitHubLoading = false.obs;
  
  // User data
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  // Form fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  
  // Form states
  final rememberMe = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final acceptTerms = false.obs;
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    super.onClose();
  }

  // ==================== Initialization ====================

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      // Check if user is logged in from secure storage
      final isLoggedIn = await _secureStorage.isLoggedIn();
      
      if (isLoggedIn) {
        // Try to get user from auth service
        if (_authService.isAuthenticated) {
          currentUser.value = _authService.currentUser;
        } else {
          // Clear stale data if user not authenticated
          await _secureStorage.clearAll();
        }
      }
      
      // Load remember me preference
      rememberMe.value = await _secureStorage.getRememberMe();
      
      // Load saved email if remember me is enabled
      if (rememberMe.value) {
        final savedEmail = await _secureStorage.getSavedEmail();
        if (savedEmail != null) {
          emailController.text = savedEmail;
        }
      }
      
      // Listen to auth state changes
      _authService.authStateChanges.listen((user) {
        if (user != null) {
          currentUser.value = _authService.currentUser;
        } else {
          currentUser.value = null;
        }
      });
      
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  // ==================== Email/Password Authentication ====================

  /// Handle login with email and password
  Future<void> login() async {
    // Validate form
    if (!loginFormKey.currentState!.validate()) {
      _showSnackBar(
        'Validation Error',
        'Please fix the errors in the form',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authService.signInWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      );

      currentUser.value = user;

      _showSnackBar(
        'Welcome Back!',
        'Successfully logged in as ${user.displayName ?? user.email}',
      );

      // Navigate to home
      Get.offAllNamed('/home');
      
      // Clear password field
      passwordController.clear();
      
    } on AuthException catch (e) {
      _showSnackBar('Login Failed', e.message, isError: true);
    } catch (e) {
      _showSnackBar('Error', 'An unexpected error occurred', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle signup with email and password
  Future<void> signUp() async {
    // Validate form
    if (!signupFormKey.currentState!.validate()) {
      _showSnackBar(
        'Validation Error',
        'Please fix the errors in the form',
        isError: true,
      );
      return;
    }

    // Check if terms are accepted
    if (!acceptTerms.value) {
      _showSnackBar(
        'Terms & Conditions',
        'Please accept the terms and conditions',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authService.signUpWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: fullNameController.text.trim(),
      );

      currentUser.value = user;

      // Show success dialog
      await _showSuccessDialog();

      // Navigate to home
      Get.offAllNamed('/home');
      
      // Clear form
      _clearSignUpForm();
      
    } on AuthException catch (e) {
      _showSnackBar('Signup Failed', e.message, isError: true);
    } catch (e) {
      _showSnackBar('Error', 'An unexpected error occurred', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Social Authentication ====================

  /// Handle Google sign in
  Future<void> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      final user = await _authService.signInWithGoogle();
      currentUser.value = user;

      _showSnackBar(
        'Welcome!',
        'Successfully signed in with Google',
      );

      // Navigate to home
      Get.offAllNamed('/home');
      
    } on AuthException catch (e) {
      _showSnackBar('Google Sign-In Failed', e.message, isError: true);
    } catch (e) {
      _showSnackBar('Error', 'An unexpected error occurred' , isError: true);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  /// Handle GitHub sign in
  Future<void> signInWithGitHub() async {
    log("Starting GitHub Sign-In");
    try {
      isGitHubLoading.value = true;

      final user = await _authService.signInWithGitHub();
      currentUser.value = user;

      _showSnackBar(
        'Welcome!',
        'Successfully signed in with GitHub',
      );

      // Navigate to home
      Get.offAllNamed('/home');
      
    } on AuthException catch (e) {
      _showSnackBar('GitHub Sign-In Failed', e.message, isError: true);
    } catch (e) {
      log("GitHub Sign-In Error: ${e.toString()}");
      _showSnackBar('Error', 'An unexpected error occurred', isError: true);
    } finally {
      isGitHubLoading.value = false;
    }
  }

  // ==================== Password Management ====================

  /// Handle forgot password
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      _showSnackBar(
        'Email Required',
        'Please enter your email address',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      await _authService.sendPasswordResetEmail(email);
      
      _showSnackBar(
        'Email Sent',
        'Password reset link has been sent to $email',
      );
      
    } on AuthException catch (e) {
      _showSnackBar('Reset Failed', e.message, isError: true);
    } catch (e) {
      _showSnackBar('Error', 'An unexpected error occurred', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      isLoading.value = true;
      
      await _authService.sendEmailVerification();
      
      _showSnackBar(
        'Verification Sent',
        'Verification email has been sent',
      );
      
    } on AuthException catch (e) {
      _showSnackBar('Verification Failed', e.message, isError: true);
    } catch (e) {
      _showSnackBar('Error', 'An unexpected error occurred', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Sign Out ====================

  /// Handle logout
  // lib/controllers/auth_controller.dart

// lib/controllers/auth_controller.dart

// lib/controllers/auth_controller.dart

Future<void> logout() async {
  try {
    // Show confirmation dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Show loading overlay (non-reactive)
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // Prevent dismissing
          child: const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Logging out...'),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Perform logout
      await _authService.signOut();
      
      // IMPORTANT: Clear user BEFORE closing dialog
      currentUser.value = null;

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // IMPORTANT: Navigate FIRST, THEN show snackbar
      // This ensures navigation completes before trying to show snackbar
      await Get.offAllNamed(AppRoutes.splash); // Go to splash, which will redirect to auth

      // Small delay to ensure navigation is complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Now show snackbar on the new page
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      
    } catch (e) {
      // Close loading dialog if error occurs
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      debugPrint('Logout error: $e');
      
      // Show error (controller is still alive here)
      Get.snackbar(
        'Logout Failed',
        e is AuthException ? e.message : 'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  } catch (e) {
    debugPrint('Logout dialog error: $e');
  }
}

  // ==================== UI Helper Methods ====================

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  /// Toggle accept terms
  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  /// Clear signup form
  void _clearSignUpForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    acceptTerms.value = false;
  }

  /// Show snackbar message
  void _showSnackBar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  /// Show success dialog after signup
  Future<void> _showSuccessDialog() async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Created!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your account has been created successfully',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ==================== Validators ====================

  /// Email validator
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Password validator
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Confirm password validator
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Full name validator
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    
    return null;
  }
}