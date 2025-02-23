import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoaningTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final double height;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLength;

  const LoaningTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.width = 430,
    this.height = 932,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    required this.maxLength,
  }) : super(key: key);

  // The SVG shape from your file.
  static const String _svgData = '''
<svg width="430" height="932" viewBox="0 0 430 932" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 -2H430V934H0V-2Z" fill="url(#paint0_linear_1_531)" fill-opacity="0.4"/>
<defs>
<linearGradient id="paint0_linear_1_531" x1="215" y1="-2" x2="215" y2="934" gradientUnits="userSpaceOnUse">
<stop offset="0.449" stop-color="#B7EEFF" stop-opacity="0.1"/>
<stop offset="1" stop-color="#55D6FF" stop-opacity="0.6"/>
</linearGradient>
</defs>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // SVG Background shape
          SvgPicture.string(
            _svgData,
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          // Text field on top of the SVG background.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
              maxLength: maxLength,
              inputFormatters: (keyboardType == TextInputType.number ||
                      keyboardType == TextInputType.phone)
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                counterText: '', // Hide counter text.
              ),
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}