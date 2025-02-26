import 'package:dion_app/core/theme/app_theme.dart';
import 'package:dion_app/features/authintication_feature/presentation/widgets/login_button.dart';
import 'package:dion_app/features/home_screen/presentation/home_screen_loans_Bloc/loaning_bloc.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../authintication_bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final String? redirect;

  LoginScreen({Key? key, this.redirect}) : super(key: key);

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff353F4F),
      appBar: AppBar(
        backgroundColor: Color(0xff353F4F),
        title: Text(
          'تسجيل الدخول',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: BlocListener<AuthenticationBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<LoaningBloc>().add(FetchLoaningData());
            context.read<ProfileCubit>().fetchProfileData();

            if (redirect != null && redirect!.isNotEmpty) {
              context.go(redirect!);
            } else {
              context.go('/main_screen');
            }
          } else if (state is AuthError || state is ConnectionError) {
            final message = state is AuthError
                ? state.message
                : (state as ConnectionError).message;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            });
          }
        },
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height*0.08,
                right: MediaQuery.sizeOf(context).width*0.05,
              left: MediaQuery.sizeOf(context).width*0.05,
              bottom: MediaQuery.sizeOf(context).height*0.08,

          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/registerImage.svg",
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text("Dion App", style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white
                ),),
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
                    return LoginButton(
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
                    Text(
                      'ليس لديك حساب؟',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.02),
                    GestureDetector(
                      onTap: () {
                        context.push('/verify_phone_number');
                      },
                      child: Text(
                        'انشاء حساب',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.mainColor, fontSize: 12),
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
    TextEditingController passwordController,
  ) {
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
