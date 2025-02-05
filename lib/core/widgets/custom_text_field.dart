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
  final String? Function(String?)? validator; // Validator function
  final Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? borderRadius;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine if the prefix icon should be a phone icon or +218
    Widget? getPrefixIcon() {
      if (keyboardType == TextInputType.phone) {
        // Check if the controller text is empty or not
        if (controller.text.isEmpty) {
          return Text(
            '+218',
            style: TextStyle(fontSize: 16, color: theme.primaryColor),
          );
        } else {
          return Icon(prefixIcon ?? Icons.phone); // Default phone icon
        }
      }
      return null; // Default case when not phone input type
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              maxLength: maxLines != null ? 144 : null,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                prefixIcon: getPrefixIcon(), // Use dynamic prefixIcon
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
                  borderSide: BorderSide(
                    color: theme.inputDecorationTheme.enabledBorder?.borderSide
                        .color ??
                        Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
                  borderSide: BorderSide(
                    color: theme.inputDecorationTheme.focusedBorder?.borderSide
                        .color ??
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
