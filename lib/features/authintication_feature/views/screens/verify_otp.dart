import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../viewmodel/auth_bloc.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController _otpController = TextEditingController();

  OtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr, // Set text direction to LTR
      child: Scaffold(
        appBar: AppBar(title: const Text('تحقق من OTP')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'تم إرسال الرمز إلى: $phoneNumber',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                ),
                onCompleted: (value) {
                  if (value.isNotEmpty) {
                    context.read<AuthenticationBloc>().add(
                      VerifyOtpEvent(
                        otpCode: value,
                        phoneNumber: phoneNumber,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthenticationBloc, AuthState>(
                listener: (context, state) {
                  if (state is OtpVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم التحقق من OTP بنجاح!')),
                    );
                    context.push('/signup', extra: phoneNumber);
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    onPressed: () {
                      final otpCode = _otpController.text;
                      if (otpCode.isNotEmpty) {
                        context.read<AuthenticationBloc>().add(
                          VerifyOtpEvent(
                            otpCode: otpCode,
                            phoneNumber: phoneNumber,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('الرجاء إدخال الرمز الذي تم إرساله')),
                        );
                      }
                    },
                    text: 'تحقق من الرمز',
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(ResendOtpEvent(phoneNumber: phoneNumber));
                },
                child: const Text('اعادة ارسال الكود'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}