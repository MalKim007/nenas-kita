/// Password validation utilities for NenasKita
class PasswordUtils {
  PasswordUtils._();

  /// Minimum password length
  static const int minLength = 8;

  /// Validates a password against security requirements.
  ///
  /// Requirements (farmer-friendly):
  /// - Minimum 8 characters
  /// - At least 1 uppercase letter
  /// - At least 1 lowercase letter
  /// - At least 1 digit
  /// - No special character requirement (easier for farmers)
  ///
  /// Example:
  /// ```dart
  /// final result = PasswordUtils.validate('Password123');
  /// if (result.isValid) {
  ///   // Proceed with registration
  /// } else {
  ///   // Show errors: result.errors
  /// }
  /// ```
  static PasswordValidationResult validate(String password) {
    final errors = <String>[];

    // Check minimum length
    if (password.length < minLength) {
      errors.add('Kata laluan mesti sekurang-kurangnya $minLength aksara');
    }

    // Check for uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Kata laluan mesti mengandungi sekurang-kurangnya 1 huruf besar');
    }

    // Check for lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('Kata laluan mesti mengandungi sekurang-kurangnya 1 huruf kecil');
    }

    // Check for digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Kata laluan mesti mengandungi sekurang-kurangnya 1 nombor');
    }

    return PasswordValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Gets password strength as a percentage (0.0 to 1.0).
  ///
  /// Criteria:
  /// - Length >= 8: +0.25
  /// - Length >= 12: +0.25
  /// - Has uppercase: +0.15
  /// - Has lowercase: +0.15
  /// - Has digit: +0.15
  /// - Has special char: +0.05
  ///
  /// Example:
  /// ```dart
  /// final strength = PasswordUtils.getStrength('Password123');
  /// // Returns: 0.80 (80% strength)
  /// ```
  static double getStrength(String password) {
    double strength = 0.0;

    // Length checks
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.25;

    // Character type checks
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.05;

    return strength.clamp(0.0, 1.0);
  }

  /// Gets a human-readable strength label.
  ///
  /// Returns:
  /// - 'Lemah' (Weak) for strength < 0.4
  /// - 'Sederhana' (Moderate) for strength < 0.7
  /// - 'Kuat' (Strong) for strength >= 0.7
  ///
  /// Example:
  /// ```dart
  /// final label = PasswordUtils.getStrengthLabel('Pass123');
  /// // Returns: 'Sederhana'
  /// ```
  static String getStrengthLabel(String password) {
    final strength = getStrength(password);
    if (strength < 0.4) return 'Lemah';
    if (strength < 0.7) return 'Sederhana';
    return 'Kuat';
  }
}

/// Result of password validation containing validity status and error messages.
class PasswordValidationResult {
  /// Whether the password meets all requirements
  final bool isValid;

  /// List of validation error messages in Malay
  final List<String> errors;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the password is invalid
  bool get isInvalid => !isValid;

  /// First error message, or null if valid
  String? get firstError => errors.isEmpty ? null : errors.first;

  /// All errors concatenated with newlines
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    if (isValid) return 'PasswordValidationResult(valid)';
    return 'PasswordValidationResult(invalid: ${errors.length} errors)';
  }
}
