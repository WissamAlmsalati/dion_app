import 'package:dio/dio.dart';
import 'package:dion_app/features/reset_password/domain/reset_password_impl.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordImpl resetPasswordImpl;

  // Variable to store otpId
  int? otpId;

  // Constructor that initializes the cubit with the ResetPasswordImpl
  ResetPasswordCubit(this.resetPasswordImpl) : super(ResetPasswordInitial());

  // Function to send OTP
  void sendOtp(String phoneNumber) async {
    emit(ResetPasswordLoading());
    try {
      final response = await resetPasswordImpl.sendOtp(phoneNumber: phoneNumber);
      otpId = response['otpId'];  // Store the otpId from the response
      emit(SendOtpSuccess());
    } catch (e) {
      emit(SendOtpFailure(e.toString()));
    }
  }

  void resetPassword(int otp, String newPassword) async {
    print("Reset Password");

    if (otpId == null) {
      emit(ResetPasswordFailure('OTP ID is missing'));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      final response = await resetPasswordImpl.resetPassword(
        otpId: otpId!,  // Ensure otpId is available
        otp: otp,
        newPassword: newPassword,
      );
      emit(ResetPasswordSuccess(message: response));
    } catch (e) {
      if (e is DioError) {
        final errorMessage = e.response?.data['message'] ?? 'Failed to reset password';
        emit(ResetPasswordFailure(errorMessage));
      } else {
        emit(ResetPasswordFailure(e.toString()));
      }
    }
  }
}
