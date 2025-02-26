import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top so error text doesn't shift layout
      children: [
        // Label on the left
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0), // Reduced padding for height
            child: Text(
              labelText,
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white
              ),
            ),
          ),
        ),
        // Text field and error on the right
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field with SVG background
              Stack(
                children: [
                  // SVG background
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "assets/images/tfBackground.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  // TextFormField with no border
                  TextFormField(
                    inputFormatters: keyboardType == TextInputType.number ||
                        keyboardType == TextInputType.phone
                        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                        : null,
                    controller: controller,
                    obscureText: obscureText,
                    maxLines: maxLines ?? 1,
                    minLines: minLines ?? 1,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      hintText: hintText,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width ?? 16,
                        vertical: height ?? 12, // Reduced height here
                      ),
                      labelStyle: theme.inputDecorationTheme.labelStyle,
                      hintStyle: theme.inputDecorationTheme.hintStyle,
                      suffixIcon: suffixIcon,
                      counterText: '', // Hide character counter
                    ),
                    keyboardType: keyboardType,
                    validator: validator,
                    onChanged: (value) {
                      if (onChanged != null) onChanged!(value); // Trigger onChanged callback
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
