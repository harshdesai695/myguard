import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.focusNode,
    this.autofillHints,
    this.onTap,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final VoidCallback? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          autofillHints: widget.autofillHints,
          onTap: widget.onTap,
          inputFormatters: widget.inputFormatters,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey500,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
