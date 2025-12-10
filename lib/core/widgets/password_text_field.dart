import 'package:flutter/material.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';

/// Password text field with visibility toggle
///
/// Features:
/// - Eye icon suffix to toggle password visibility
/// - Obscure text by default
/// - Standard text field properties (controller, label, error, etc.)
/// - Follows Material Design and app theming
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      helperText: widget.helperText,
      obscureText: _obscureText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
      onSuffixIconTap: widget.enabled ? _toggleVisibility : null,
    );
  }
}
