import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CustomPhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CustomPhoneTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLength: 9,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        // The hint for the phone number.
        hintText: '910000000',
        hintStyle: const TextStyle(color: Colors.grey),
        // Use the prefix property to display the country code inside the same container.
        suffix: Container(
          width: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '218+',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppTheme.mainColor, width: 2.0),
        ),
        counterText: '', // Hides the built-in counter.
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
