import 'package:dion_app/core/widgets/custom_button.dart';
import 'package:dion_app/core/widgets/custom_text_field.dart';
import 'package:dion_app/features/authintication_feature/viewmodel/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _phoneController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _phoneController,
                labelText: 'رقم الهاتف',
                hintText: '910000000',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _validatePhoneNumber,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'كلمة المرور',
                hintText: 'أدخل كلمة المرور',
                prefixIcon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthenticationBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
                    );
                    context.go('/main_screen');
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    print(state.message);
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onLoginPressed(context, _phoneController, _passwordController);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('يرجى إدخال تفاصيل صحيحة')),
                        );
                      }
                    },
                    text: "تسجيل الدخول",
                    isLoading: state is AuthLoading,
                  );
                },
              ),
              Text('ليس لديك حساب؟'),

            ],

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

  void _onLoginPressed(BuildContext context, TextEditingController phoneController, TextEditingController passwordController) {
    final phoneNumber = '0' + phoneController.text;
    final password = passwordController.text;
    context.read<AuthenticationBloc>().add(LoginEvent(
        phoneNumber: phoneNumber, password: password));
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