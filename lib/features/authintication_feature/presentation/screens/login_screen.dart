import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../authintication_bloc/auth_bloc.dart';
import '../../domain/repository/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تسجيل الدخول',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: BlocListener<AuthenticationBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError || state is ConnectionError) {
            final message = state is AuthError ? state.message : (state as ConnectionError).message;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/registerImage.svg",
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: 100,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  hintText: '910000000',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                  maxLength: 9,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور',
                  prefixIcon: Icons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: _validatePassword,
                  maxLength: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push("/reset_pass_phone_screen");
                    },
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                BlocBuilder<AuthenticationBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onLoginPressed(
                              context, _phoneController, _passwordController);
                        }
                      },
                      text: 'تسجيل الدخول',
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    GestureDetector(
                      onTap: () {
                        context.push('/');
                      },
                      child: const Text(
                        'انشاء حساب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    // Validate phone number starting with 91, 92, 93, or 94 followed by 7 digits
    final regex = RegExp(r'^(91|92|93|94)\d{7}$');

    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    } else if (!regex.hasMatch(value)) {
      return 'رقم الهاتف يجب أن يبدأ ب 91 أو 92 أو 93 أو 94 ويجب أن يتكون من 9 أرقام';
    }
    return null;
  }

  void _onLoginPressed(
      BuildContext context,
      TextEditingController phoneController,
      TextEditingController passwordController) {
    final phoneNumber = phoneController.text;
    final password = passwordController.text;
    context
        .read<AuthenticationBloc>()
        .add(LoginEvent(phoneNumber: phoneNumber, password: password));
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    } else if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل';
    }
    return null;
  }
}
