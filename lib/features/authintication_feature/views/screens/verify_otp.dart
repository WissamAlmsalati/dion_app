import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart'; // Import the package
import '../../../../core/widgets/custom_button.dart';
import '../../viewmodel/auth_bloc.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController _otpController = TextEditingController();

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الرقم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'تم الارسال : $phoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 6,
              // Number of OTP digits
              controller: _otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
              ),
              onCompleted: (value) {
                // Automatically trigger OTP verification when all digits are entered
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
                    const SnackBar(content: Text('تم التحقق بنجاح!')),
                  );
                  context.go('/signup', extra: phoneNumber);
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
                            content: Text('الرجاء ادخال الرمز الذي تم ارساله')),
                      );
                    }
                  },
                  text: 'تاكيد الرمز',
                );
              },
            ),
            TextButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(ResendOtpEvent(phoneNumber: phoneNumber));
                },
                child: Text('اعادة ارسال الرمز')),

          ],
        ),
      ),
    );
  }
}
