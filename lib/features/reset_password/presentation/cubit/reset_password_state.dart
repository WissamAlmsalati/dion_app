abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class SendOtpLoading extends ResetPasswordState {}

class SendOtpSuccess extends ResetPasswordState {


}

class SendOtpFailure extends ResetPasswordState {
  final String error;
  SendOtpFailure(this.error);
}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess({required this.message});
}

class ResendOtpSuccess extends ResetPasswordState {}

class ResendOtpFailure extends ResetPasswordState {
  final String error;
  ResendOtpFailure(this.error);
}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;
  ResetPasswordFailure(this.error);
}
