// lib/services/auth_services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_book/model/user_model.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';
import 'auth_exceptions.dart';


/// Authentication service handling all authentication operations
/// Implements Firebase Authentication with Email/Password, Google, and GitHub
class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();

  late final FirebaseAuth _auth;
  late final GoogleSignIn _googleSignIn;
  final _secureStorage = SecureStorageService.instance;

  // Observable current user
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get firebaseUser => _firebaseUser.value;
  
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn.instance;
    
    // Bind auth state to reactive user
    _firebaseUser.bindStream(_auth.authStateChanges());
    
    // Update UserModel when Firebase user changes
    ever(_firebaseUser, _setInitialScreen);
  }

  /// Handle initial screen routing based on auth state
  void _setInitialScreen(User? user) {
    if (user != null) {
      _currentUser.value = UserModel.fromFirebaseUser(user, _getProviderType(user));
    } else {
      _currentUser.value = null;
    }
  }

  /// Get provider type from Firebase user
  String _getProviderType(User user) {
    if (user.providerData.isEmpty) return 'email';
    
    final providerId = user.providerData.first.providerId;
    if (providerId.contains('google')) return 'google';
    if (providerId.contains('github')) return 'github';
    return 'email';
  }

  // ==================== Email/Password Authentication ====================

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
        await credential.user?.reload();
      }

      // Send email verification
      await credential.user?.sendEmailVerification();

      final user = UserModel.fromFirebaseUser(credential.user!, 'email');
      
      // Save user data to secure storage
      await _secureStorage.saveUserData(user);
      await _secureStorage.setLoginStatus(true);
      
      _currentUser.value = user;
      return user;
      
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(
        code: 'signup-failed',
        message: 'Failed to create account: ${e.toString()}',
      );
    }
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = UserModel.fromFirebaseUser(credential.user!, 'email');
      
      // Save user data and remember me preference
      await _secureStorage.saveUserData(user);
      await _secureStorage.setLoginStatus(true);
      await _secureStorage.saveRememberMe(
        rememberMe: rememberMe,
        email: email.trim(),
      );

      // Save auth token
      final token = await credential.user?.getIdToken();
      if (token != null) {
        await _secureStorage.saveAuthToken(token);
      }
      
      _currentUser.value = user;
      return user;
      
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(
        code: 'signin-failed',
        message: 'Failed to sign in: ${e.toString()}',
      );
    }
  }

  // ==================== Google Authentication ====================

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow (request email/profile scopes)
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      
      if (googleUser == null) {
        throw AuthException(
          code: 'user-cancelled',
          message: 'Google sign-in was cancelled',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final user = UserModel.fromFirebaseUser(userCredential.user!, 'google');
      
      // Save user data
      await _secureStorage.saveUserData(user);
      await _secureStorage.setLoginStatus(true);

      // Save auth token
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await _secureStorage.saveAuthToken(token);
      }
      
      _currentUser.value = user;
      return user;
      
    } on FirebaseAuthException catch (e) {
      await _googleSignIn.signOut(); // Clean up
      throw AuthException.fromCode(e.code);
    } catch (e) {
      await _googleSignIn.signOut(); // Clean up
      throw AuthException(
        code: 'google-signin-failed',
        message: 'Google sign-in failed: ${e.toString()}',
      );
    }
  }

  // ==================== GitHub Authentication ====================

  /// Sign in with GitHub
  Future<UserModel> signInWithGitHub() async {
    try {
      // Create GitHub provider
      final githubProvider = GithubAuthProvider();
      
      // Add scopes
      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      // Sign in with popup/redirect
      final UserCredential userCredential = await _auth.signInWithProvider(githubProvider);

      final user = UserModel.fromFirebaseUser(userCredential.user!, 'github');
      
      // Save user data
      await _secureStorage.saveUserData(user);
      await _secureStorage.setLoginStatus(true);

      // Save auth token
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await _secureStorage.saveAuthToken(token);
      }
      
      _currentUser.value = user;
      return user;
      
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(
        code: 'github-signin-failed',
        message: 'GitHub sign-in failed: ${e.toString()}',
      );
    }
  }

  // ==================== User Management ====================

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw AuthException(
        code: 'verification-failed',
        message: 'Failed to send verification email: ${e.toString()}',
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(
        code: 'password-reset-failed',
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
      
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
        final user = UserModel.fromFirebaseUser(updatedUser, _getProviderType(updatedUser));
        _currentUser.value = user;
        await _secureStorage.saveUserData(user);
      }
    } catch (e) {
      throw AuthException(
        code: 'update-failed',
        message: 'Failed to update display name: ${e.toString()}',
      );
    }
  }

  /// Update user photo URL
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoUrl);
      await _auth.currentUser?.reload();
      
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
        final user = UserModel.fromFirebaseUser(updatedUser, _getProviderType(updatedUser));
        _currentUser.value = user;
        await _secureStorage.saveUserData(user);
      }
    } catch (e) {
      throw AuthException(
        code: 'update-failed',
        message: 'Failed to update photo: ${e.toString()}',
      );
    }
  }

  /// Reload current user data
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
        final user = UserModel.fromFirebaseUser(updatedUser, _getProviderType(updatedUser));
        _currentUser.value = user;
        await _secureStorage.saveUserData(user);
      }
    } catch (e) {
      throw AuthException(
        code: 'reload-failed',
        message: 'Failed to reload user: ${e.toString()}',
      );
    }
  }

  // ==================== Sign Out ====================

  /// Sign out from all providers
  Future<void> signOut() async {
    try {
      // Sign out from Google if a user is currently signed in
      if (currentUser != null) {
        await _googleSignIn.signOut();
      }
      
      // Sign out from Firebase
      await _auth.signOut();
      
      // Clear secure storage
      await _secureStorage.clearAll();
      
      _currentUser.value = null;
      
    } catch (e) {
      throw AuthException(
        code: 'signout-failed',
        message: 'Failed to sign out: ${e.toString()}',
      );
    }
  }

  // ==================== Utility Methods ====================

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get current Firebase auth token
  Future<String?> getAuthToken() async {
    try {
      return await _auth.currentUser?.getIdToken();
    } catch (e) {
      return null;
    }
  }

  /// Refresh auth token
  Future<String?> refreshAuthToken() async {
    try {
      final token = await _auth.currentUser?.getIdToken(true);
      if (token != null) {
        await _secureStorage.saveAuthToken(token);
      }
      return token;
    } catch (e) {
      return null;
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      await _secureStorage.clearAllIncludingRememberMe();
      _currentUser.value = null;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(
        code: 'delete-failed',
        message: 'Failed to delete account: ${e.toString()}',
      );
    }
  }
}