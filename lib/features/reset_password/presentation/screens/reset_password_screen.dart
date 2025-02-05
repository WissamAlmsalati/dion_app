import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/reset_password_bloc.dart';
import '../cubit/reset_password_state.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpControl = TextEditingController();
    final TextEditingController passwordControl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("إعادة تعيين كلمة المرور"),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: otpControl,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      hintText: 'أدخل OTP هنا',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordControl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      hintText: 'أدخل كلمة المرور الجديدة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
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
                    child: const Text('إعادة تعيين كلمة المرور'),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(   '${state.error}')),
            );
          } else if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.push('/login');
          }
        },
      ),
    );
  }
}