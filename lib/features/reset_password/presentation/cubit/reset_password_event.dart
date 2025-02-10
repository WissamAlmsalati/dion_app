class ResetPasswordEvent {}

class SendOtpEvent extends ResetPasswordEvent {
  final String phoneNumber;
  SendOtpEvent(this.phoneNumber);
}

class ResetPassword extends ResetPasswordEvent {
  final String otpId;
  final int otp;
  final String newPassword;
  ResetPassword(this.otpId, this.otp, this.newPassword);
}



