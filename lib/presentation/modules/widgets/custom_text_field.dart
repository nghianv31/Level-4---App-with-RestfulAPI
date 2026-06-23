import 'package:flutter/material.dart';
import '../../../core/theme/AppTheme.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool isRequired;
  final bool obscureText;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
    this.isRequired = false,
    this.obscureText = false,
    this.suffix,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  bool _isValid = false;
  bool _isDirty = false;

  void _validate(String value) {
    if (widget.validator == null) return;
    final error = widget.validator?.call(value);
    setState(() {
      _errorText = error;
      _isValid = error == null && (_isDirty || value.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: (value) {
            _isDirty = true;
            _validate(value);
          },
          validator: (value) {
            final error = widget.validator?.call(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _errorText = error;
                  _isValid = error == null && (value?.isNotEmpty ?? false);
                });
              }
            });
            return error;
          },
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 15,
            color: AppTheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppTheme.neutralColor, fontSize: 14),
            prefixIcon: Icon(widget.prefixIcon, color: AppTheme.neutralColor, size: 20),
            
            // Suffix icon thể hiện kết quả xác thực trực quan hoặc widget tùy biến từ bên ngoài (như mắt ẩn/hiện mật khẩu)
            suffixIcon: widget.suffix ?? (_errorText != null
                ? const Icon(
                    Icons.warning_rounded,
                    color: AppTheme.errorColor,
                    size: 20,
                  )
                : _isValid
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.secondaryColor,
                        size: 20,
                      )
                    : null),
                    
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            
            // Cấu hình viền chuẩn 12px bo tròn theo thiết kế
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineVariant, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineVariant, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
