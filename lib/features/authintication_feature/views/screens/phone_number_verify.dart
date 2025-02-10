import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_text_phone_number_field.dart';
import '../../viewmodel/auth_bloc.dart';
import '../../repository/auth_repository.dart';

class VerifyPhoneNumber extends StatefulWidget {
  VerifyPhoneNumber({Key? key}) : super(key: key);

  @override
  _VerifyPhoneNumberState createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize the FocusNode
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(authRepository: AuthRepository()),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();

        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).height * 0.04,
                right: MediaQuery.sizeOf(context).height * 0.04,
                top: MediaQuery.sizeOf(context).height * 0.02,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                    Text(
                      "انشاء حساب",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.mainColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                    Text(
                      "لاستخدام التطبيق يجب عليك اولاانشاء حساب",
                      
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                    SvgPicture.asset(
                      "assets/images/registerImage.svg",
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      width: 100,
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
                    CustomPhoneTextField(
                      focusNode: _focusNode, // Pass the FocusNode here
                      validator: _validatePhoneNumber,
                      controller: _phoneController,
                    ),
                     SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                    // Using BlocConsumer to listen and build
                    BlocConsumer<AuthenticationBloc, AuthState>(
                      listener: (context, state) {
                        if (state is OtpSent) {
                          print("OTP Sent: ${state.otp}, Expires At: ${state.expiresAt}");
                          context.push('/signup', extra: {
                            'phoneNumber': _phoneController.text,
                            'otp': state.otp ?? "",
                            'expiresAt': state.expiresAt ?? "",
                          });
                        }
                        if (state is AuthError || state is ConnectionError) {
                          final message = state is AuthError
                              ? state.message
                              : (state as ConnectionError).message;
                          print(message);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: state is ConnectionError ? Colors.orange : Colors.red,
                            ),
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
                     SizedBox(height:  MediaQuery.sizeOf(context).height * 0.02),
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
