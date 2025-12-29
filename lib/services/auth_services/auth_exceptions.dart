// lib/services/auth_services/auth_exceptions.dart

/// Custom exception class for authentication-related errors
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({
    required this.message,
    required this.code,
  });

  @override
  String toString() => message;

  /// Factory constructor to create AuthException from Firebase error codes
  factory AuthException.fromCode(String code) {
    switch (code) {
      // Email/Password Authentication Errors
      case 'invalid-email':
        return AuthException(
          code: code,
          message: 'The email address is not valid.',
        );
      case 'user-disabled':
        return AuthException(
          code: code,
          message: 'This user account has been disabled.',
        );
      case 'user-not-found':
        return AuthException(
          code: code,
          message: 'No user found with this email.',
        );
      case 'wrong-password':
        return AuthException(
          code: code,
          message: 'Incorrect password. Please try again.',
        );
      case 'email-already-in-use':
        return AuthException(
          code: code,
          message: 'An account already exists with this email.',
        );
      case 'weak-password':
        return AuthException(
          code: code,
          message: 'Password should be at least 6 characters long.',
        );
      case 'operation-not-allowed':
        return AuthException(
          code: code,
          message: 'This sign-in method is not enabled.',
        );
      
      // Google Sign-In Errors
      case 'account-exists-with-different-credential':
        return AuthException(
          code: code,
          message: 'An account already exists with a different sign-in method.',
        );
      case 'invalid-credential':
        return AuthException(
          code: code,
          message: 'The credential is malformed or expired.',
        );
      case 'credential-already-in-use':
        return AuthException(
          code: code,
          message: 'This credential is already associated with another account.',
        );
      
      // GitHub Sign-In Errors
      case 'github-signin-failed':
        return AuthException(
          code: code,
          message: 'GitHub sign-in failed. Please try again.',
        );
      
      // Network Errors
      case 'network-request-failed':
        return AuthException(
          code: code,
          message: 'Network error. Please check your internet connection.',
        );
      case 'too-many-requests':
        return AuthException(
          code: code,
          message: 'Too many attempts. Please try again later.',
        );
      
      // Generic Errors
      case 'user-cancelled':
        return AuthException(
          code: code,
          message: 'Sign-in was cancelled.',
        );
      case 'popup-closed-by-user':
        return AuthException(
          code: code,
          message: 'Sign-in popup was closed before completion.',
        );
      
      default:
        return AuthException(
          code: 'unknown',
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }
}