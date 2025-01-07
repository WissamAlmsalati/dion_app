part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event to check if the app is starting
class AppStarted extends AuthEvent {}

// Event to send OTP
class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class ResendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const ResendOtpEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

// Event to verify OTP
class VerifyOtpEvent extends AuthEvent {
  final String otpCode;
  final String phoneNumber;

  const VerifyOtpEvent({required this.otpCode, required this.phoneNumber});

  @override
  List<Object?> get props => [otpCode, phoneNumber];
}

// Event to handle sign-up
class SignUpEvent extends AuthEvent {
  final User user;

  const SignUpEvent({required this.user});
  @override
  List<Object?> get props => [user];

}


class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({required this.phoneNumber, required this.password});

  @override
  List<Object?> get props => [phoneNumber, password];
}

class LogoutEvent extends AuthEvent {}