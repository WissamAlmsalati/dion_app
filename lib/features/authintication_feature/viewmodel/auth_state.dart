part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;

  const Authenticated({required this.token});

  @override
  List<Object?> get props => [token];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class SignUpSuccess extends AuthState {
  final String message;

  const SignUpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogOutSucess extends AuthState {}

class LogOutError extends AuthState {
  final String message;

  const LogOutError({required this.message});

  @override
  List<Object?> get props => [message];
}