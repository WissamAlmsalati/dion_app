import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText; // kept in case you need it for reference but not shown
  final String? hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? borderRadius; // This will not be used now
  final Widget? suffixIcon;
  final int maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.height,
    this.width,
    this.borderRadius,
    this.suffixIcon,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            inputFormatters: keyboardType == TextInputType.number ||
                    keyboardType == TextInputType.phone
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines ?? 1,
            minLines: minLines ?? 1,
            maxLength: maxLength,
            decoration: InputDecoration(
              // Removed labelText to not show any label
              hintText: hintText,
              // Underline style borders
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                      Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.inputDecorationTheme.focusedBorder?.borderSide.color ?? Colors.blue,
                  width: 2.0,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.inputDecorationTheme.errorBorder?.borderSide.color ?? Colors.red,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.inputDecorationTheme.focusedErrorBorder?.borderSide.color ?? Colors.red,
                  width: 2.0,
                ),
              ),
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                horizontal: height ?? 16,
                vertical: width ?? 20,
              ),
              labelStyle: theme.inputDecorationTheme.labelStyle,
              hintStyle: theme.inputDecorationTheme.hintStyle,
              suffixIcon: suffixIcon,
              counterText: '', // This hides the counter text
            ),
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}