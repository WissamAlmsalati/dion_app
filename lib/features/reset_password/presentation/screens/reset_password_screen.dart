import 'package:dion_app/core/widgets/custom_button.dart';
import 'package:dion_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Import for Timer

import '../cubit/reset_password_bloc.dart';
import '../cubit/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  int _resendCountdown = 120; // Set countdown to 2 minutes (120 seconds)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Start countdown on screen load
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel previous timer if exists
    setState(() {
      _resendCountdown = 120; // Reset countdown to 2 minutes
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpControl.dispose();
    passwordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إعادة تعيين كلمة المرور"),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.push('/login');
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTextField(
                    controller: otpControl,
                    labelText: "رسالة التحقق",
                    hintText: '123456',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 6,
                  ),

                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordControl,
                    obscureText: true,
                    labelText: 'كلمة المرور الجديدة',
                    hintText: 'أدخل كلمة المرور الجديدة',
                    prefixIcon: Icons.lock,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 8,
                  ),
                  const SizedBox(height: 16),

                  // Reset Password Button
                  CustomButton(
                    onPressed: () {
                      final otp = int.tryParse(otpControl.text.trim()) ?? 0;
                      final newPassword = passwordControl.text.trim();
                      if (otp > 0 && newPassword.isNotEmpty) {
                        context.read<ResetPasswordCubit>().resetPassword(otp, newPassword);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('الرجاء إدخال OTP صحيح وكلمة مرور جديدة'),
                          ),
                        );
                      }
                    },
                    text: 'إعادة تعيين كلمة المرور',
                    isLoading: state is ResetPasswordLoading,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // Resend OTP Button with Countdown
                  _resendCountdown > 0
                      ? Text(
                          'يمكنك إعادة إرسال OTP بعد $_resendCountdown ثانية',
                          style: const TextStyle(color: Colors.grey),
                        )
                      : TextButton(
                          onPressed: () {
                            context.read<ResetPasswordCubit>().resendOtp(widget.phoneNumber);
                            _startCountdown(); // Restart countdown
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إرسال OTP جديد'),
                              ),
                            );
                          },
                          child: const Text(
                            'إعادة إرسال OTP',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
