import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? MediaQuery.sizeOf(context).height * 0.05,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center, // Centers the child widget
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.defaultFontColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
