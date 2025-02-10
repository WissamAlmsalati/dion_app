import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
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
  final double? borderRadius;
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
          Container(
            child: TextFormField(
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
                labelText: labelText,
                hintText: hintText,
            
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
                  borderSide: BorderSide(
                    color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                        Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
                  borderSide: BorderSide(
                    color: theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
                        Colors.blue,
                    width: 2.0,
                  ),
                ),
                errorBorder: theme.inputDecorationTheme.errorBorder,
                focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: height ?? 16,
                  vertical: width ?? 20,
                ),
                labelStyle: theme.inputDecorationTheme.labelStyle,
                hintStyle: theme.inputDecorationTheme.hintStyle,
                suffixIcon: suffixIcon, // Use the passed suffixIcon for password visibility toggle
                // Hide the counter under the TextField
                counterText: '',  // This hides the counter text
              ),
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

 
}
