import 'package:dion_app/core/widgets/custom_button.dart';
import 'package:dion_app/core/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/validators.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../viewmodel/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  final String phoneNumber;

  const SignUpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _name = TextEditingController();
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();
    final _formKey = GlobalKey<FormState>(); // Add a form key for validation

    return BlocProvider(
      create: (BuildContext context) {
        return AuthenticationBloc(
          authService: AuthService(
          ),
         );
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('انشاء حساب جديد',
                style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        body: BlocConsumer<AuthenticationBloc, AuthState>(
          builder: (BuildContext context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey, // Assign the form key
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _name,
                      labelText: 'الاسم',
                      hintText: 'يرجى إدخال اسمك',
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.text,
                      validator: validateName, // Pass the validator
                    ),
                    CustomTextField(
                      controller: _email,
                      labelText: 'البريد الإلكتروني',
                      hintText: 'أدخل بريدك الإلكتروني',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail, // Pass the validator
                    ),
                    CustomTextField(
                      controller: _password,
                      labelText: 'كلمة المرور',
                      hintText: 'يرجى إدخال كلمة المرور',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: validatePassword, // Pass the validator
                    ),
                    Text('رقم الهاتف هو: $phoneNumber'),
                    CustomButton(
                      onPressed: () {
                        print(phoneNumber  + "phone number");

                        // Validate the form and submit the SignUpEvent to the Bloc if valid.
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationBloc>().add(SignUpEvent(
                                user: User(
                                  name: _name.text,
                                  email: _email.text,
                                  password: _password.text,
                                  phoneNumber: phoneNumber,
                                  fcmToken: '',
                                ),
                              ));
                        }
                      },
                      text: "تسجيل",
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تسجيل الحساب بنجاح!')),
              );
              Navigator.pushNamed(context, '/login');
            }
          },
        ),
      ),
    );
  }
}
