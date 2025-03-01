import 'package:dion_app/core/theme/app_theme.dart';
import 'package:dion_app/features/authintication_feature/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_text_phone_number_field.dart';
import '../authintication_bloc/auth_bloc.dart';
import '../../domain/repository/auth_repository.dart';

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
          backgroundColor: Color(0xff353F4F),
          appBar: AppBar(
            backgroundColor: Color(0xff353F4F),
            title: Text(
              'انشاء حساب',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
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
            
            
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                    SvgPicture.asset(
                      "assets/images/registerImage.svg",
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      width: 100,
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
                    CustomTextField(
                      validator: _validatePhoneNumber,
                      controller: _phoneController, labelText: "رقم الهاتف", maxLength: 9,
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
                        return LoginButton(
                                                height: MediaQuery.sizeOf(context).height * 0.07,
            
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
                         Text('لديك حساب؟',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                           color: Colors.white
                         ),),
                     SizedBox(width: MediaQuery.sizeOf(context).height * 0.01),
                        GestureDetector(
                          onTap: () {
                            context.push('/login');
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: AppTheme.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
