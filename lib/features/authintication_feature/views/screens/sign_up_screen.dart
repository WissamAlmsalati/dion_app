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

  SignUpScreen({super.key, required this.phoneNumber});
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AuthenticationBloc(
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('انشاء حساب جديد',
              style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _name,
                    labelText: 'الاسم',
                    hintText: 'يرجى إدخال اسمك',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                    validator: validateName,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    controller: _email,
                    labelText: 'البريد الإلكتروني',
                    hintText: 'أدخل بريدك الإلكتروني',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    controller: _password,
                    labelText: 'كلمة المرور',
                    hintText: 'يرجى إدخال كلمة المرور',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text('رقم الهاتف هو: $phoneNumber'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  BlocConsumer<AuthenticationBloc, AuthState>(
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تسجيل الحساب بنجاح!')),
                        );
                        Navigator.pushNamed(context, '/login');
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
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(SignUpEvent(
                                  user: User(
                                    name: _name.text ,
                                    email: _email.text ,
                                    password: _password.text,
                                    phoneNumber: phoneNumber,
                                    fcmToken: '',
                                  ),
                                ));
                          }
                        },
                        text: "تسجيل",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}