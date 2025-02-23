import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../authintication_bloc/auth_bloc.dart';
import '../../domain/repository/auth_repository.dart';
import '../../data/models/user_model.dart'; // Ensure this import is present

class SignUpScreen extends StatelessWidget {
  final String phoneNumber;
  final int otp;
  final String expiresAt;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).width * 0.1,
                left: MediaQuery.sizeOf(context).width * 0.1,
                right: MediaQuery.sizeOf(context).width * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "مرحبا", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 30.0,
                        color: AppTheme.mainColor,
                      ),
                    ),
                    Text(
                      "يرجي انشاء حساب لاستخدام التطبيق",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18.0,
                            color: AppTheme.textColor.withOpacity(0.5),
                          ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),
                    SvgPicture.asset("assets/images/registerImage.svg"),
                    CustomTextField(
                      width: MediaQuery.sizeOf(context).height * 0.01,
                      controller: _nameController,
                      labelText: 'الاسم',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الاسم';
                        }
                        return null;
                      },
                      maxLength: 20,
                    ),
                    CustomTextField(
                      width: MediaQuery.sizeOf(context).height * 0.01,

                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        return null;
                      },
                      maxLength: 20,
                    ),
                    CustomTextField(
                      width: MediaQuery.sizeOf(context).height * 0.01,

                      controller: _passwordController,
                      labelText: 'كلمة المرور',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        return null;
                      },
                      maxLength: 8,
                    ),
                    CustomTextField(
                      width: MediaQuery.sizeOf(context).height * 0.01,

                      controller: _otpController,
                      labelText: 'رمز التحقق',
                      hintText: '123456',
                      prefixIcon: Icons.password_rounded,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رمز التحقق';
                        }
                        return null;
                      },
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthenticationBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignUpSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                          context.go('/login');
                        } else if (state is AuthError) {
                          // معالجة خطأ التسجيل وعرض رسالة الخطأ من الخادم
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is ConnectionError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          height: MediaQuery.sizeOf(context).height * 0.07,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final user = User(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phoneNumber: phoneNumber,
                                fcmToken: 'dummy_fcm_token',
                                otpCode: _otpController.text,
                                otpId: otp.toString(),
                              );
                              context
                                  .read<AuthenticationBloc>()
                                  .add(SignUpEvent(user: user));
                            }
                          },
                          text: state is AuthLoading ? "جاري التسجيل..." : "تسجيل",
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}