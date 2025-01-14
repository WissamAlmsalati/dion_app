import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../viewmodel/auth_bloc.dart';

class VerifyPhoneNumber extends StatelessWidget {
  VerifyPhoneNumber({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  hintText: '910000000',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,

                ),
                const SizedBox(height: 20),
                BlocListener<AuthenticationBloc, AuthState>(
                  listener: (context, state) {
                    print('Current State: $state'); // Debug state transitions
                    if (state is OtpSent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال OTP بنجاح!')),
                      );
                      context.push('/otp', extra: _phoneController.text);
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: BlocBuilder<AuthenticationBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final phoneNumber = _phoneController.text;
                            context.read<AuthenticationBloc>().add(
                              SendOtpEvent(phoneNumber: phoneNumber),
                            );
                          }
                        },
                        text: 'تأكيد رقم الهاتف',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('لديك حساب بالفعل؟')),
                const SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(9[1-9]\d{7})$');
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    } else if (!regex.hasMatch(value)) {
      return 'رقم الهاتف يجب ان يبدا ب 91 او 92 او 94 و 8 ارقام';
    }
    return null;
  }
}