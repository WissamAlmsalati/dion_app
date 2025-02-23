import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const LoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 195,
    this.height = 45,
  }) : super(key: key);

  // The provided SVG data as a constant string.
  static const String _svgData = '''
<svg width="195" height="45" viewBox="0 0 195 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M194.67 0V28.71L180.46 45H0V13.99L11.11 0H194.67Z" fill="black"/>
</svg>

''';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.string(
              _svgData,
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}