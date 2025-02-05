import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_text_phone_number_field.dart';
import '../../viewmodel/auth_bloc.dart';
import '../../repository/auth_repository.dart';

class VerifyPhoneNumber extends StatelessWidget {
  VerifyPhoneNumber({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.only(
              left:  MediaQuery.sizeOf(context).height  * 0.04,
              right:  MediaQuery.sizeOf(context).height  * 0.04,
              top:  MediaQuery.sizeOf(context).height  * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                SizedBox(height: MediaQuery.sizeOf(context).height  * 0.04,),
                  Text("انشاء حساب",style:Theme.of(context).textTheme.displaySmall,),

                  Text("لاستخدام التطبيق يجب عليك اولاانشاء حساب",style:Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: AppTheme.textColor.withOpacity(0.5)
                  ),),
                  SizedBox(height: MediaQuery.sizeOf(context).height  * 0.04,),

                  SvgPicture.asset("assets/images/registerImage.svg",height: MediaQuery.sizeOf(context).height * 0.2,width: 100,),

                  SizedBox(height: MediaQuery.sizeOf(context).height  * 0.08,),


                  CustomPhoneTextField(

                    controller: _phoneController,

                  ),

                  const SizedBox(height: 20),
                  BlocListener<AuthenticationBloc, AuthState>(
                    listener: (context, state) {
                      if (state is OtpSent) {
                        print("OTP Sent: ${state.otp}, Expires At: ${state.expiresAt}");
                        context.push('/signup', extra: {
                          'phoneNumber': _phoneController.text ?? "",
                          'otp': state.otp?? "  ",
                          'expiresAt': state.expiresAt ?? "", //
                        });
                      }


                      if (state is AuthError || state is ConnectionError) {
                        final message = state is AuthError
                            ? state.message
                            : (state as ConnectionError).message;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: state is ConnectionError
                                ? Colors.orange
                                : Colors.red,
                          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لديك حساب؟'),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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