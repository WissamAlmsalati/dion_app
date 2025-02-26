import 'package:dion_app/core/widgets/custom_button.dart';
import 'package:dion_app/core/widgets/custom_text_field.dart';
import 'package:dion_app/features/authintication_feature/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_bloc.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff353F4F),

      appBar: AppBar(
        backgroundColor: Color(0xff353F4F),

        title:  Text('إعادة تعيين كلمة المرور',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white
        ),),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          if (state is ResetPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SvgPicture.asset(
                        'assets/images/registerImage.svg',
                        height: MediaQuery.sizeOf(context).height * 0.2,
                      ),

                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),


                       CustomTextField(
                        controller: _phoneController,
                        labelText: 'رقم الهاتف',
                        hintText: '910000000',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                        maxLength: 9,
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      

                      LoginButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final phoneNumber = _phoneController.text.trim();
                            context.read<ResetPasswordCubit>().sendOtp(phoneNumber);
                          } else {
                            // If validation fails, a Snackbar will show error
                          }
                        },
                        text: 'التالي',
                      ),

                      const SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        listener: (context, state) {
          if (state is ResetPasswordLoading) {
            // Optionally show loading state feedback here
          } else if (state is SendOtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال OTP بنجاح!')),
            );
context.push(
  "/reset_pass_otp_screen",
  extra: {'phoneNumber':_phoneController.text }, // Pass the phone number
);
          } else if (state is SendOtpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ: ${state.error}')),
            );
          }
        },
      ),
    );
  }

  // Custom validator function
  String? _validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(91|92|93|94)\d{7}$'); // Phone number validation regex
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف'; // Arabic error message
    } else if (!regex.hasMatch(value)) {
      return 'رقم الهاتف يجب أن يبدأ بـ 91 أو 92 أو 93 أو 94 ويجب أن يتكون من 9 أرقام'; // Arabic error message
    }
    return null; // No error
  }
}
