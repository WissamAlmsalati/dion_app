import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_bloc.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_state.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعادة تعيين كلمة المرور'),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          if (state is ResetPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final phoneNumber = _phoneController.text.trim();
                            context.read<ResetPasswordCubit>().sendOtp(phoneNumber);
                          } else {
                            // If validation fails, a Snackbar will show error
                          }
                        },
                        child: const Text('إرسال OTP'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        listener: (context, state) {
          if (state is ResetPasswordLoading) {
            // Optionally show loading state feedback here
          } else if (state is SendOtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال OTP بنجاح!')),
            );
            context.push("/reset_pass_otp_screen");
          } else if (state is SendOtpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ: ${state.error}')),
            );
          }
        },
      ),
    );
  }

  // Custom validator function
  String? _validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(91|92|93|94)\d{7}$'); // Phone number validation regex
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف'; // Arabic error message
    } else if (!regex.hasMatch(value)) {
      return 'رقم الهاتف يجب أن يبدأ بـ 91 أو 92 أو 93 أو 94 ويجب أن يتكون من 9 أرقام'; // Arabic error message
    }
    return null; // No error
  }
}
