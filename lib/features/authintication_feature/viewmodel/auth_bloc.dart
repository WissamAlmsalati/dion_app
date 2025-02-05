import 'dart:convert';
import 'dart:io';
import 'package:dion_app/features/authintication_feature/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../repository/auth_repository.dart';
import '../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final AuthService authService = AuthService();
  final AuthRepository authRepository;

  AuthenticationBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SendOtpEvent>(_onSendOtp);
    on<SignUpEvent>(_onSignUp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthChecking()); // New state to indicate loading at startup
    try {
      final token = await authService.getToken();
      if (token != null) {
        emit(Authenticated(token: token));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: "Initialization failed: ${e.toString()}"));
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final responseData = await authRepository.sendOtp(event.phoneNumber);
      final otp = responseData['otp'];
      final expiresAt = responseData['expiresAt'];
      emit(OtpSent(otp: otp, expiresAt: expiresAt));
    } on SocketException {
      emit(ConnectionError(message: "No internet connection"));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.verifyOtp(event.phoneNumber, event.otpCode);
      emit(OtpVerified());
    } on SocketException {
      emit(ConnectionError(message: "No internet connection"));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp({
        "name": event.user.name,
        "email": event.user.email,
        "password": event.user.password,
        "phoneNumber": event.user.phoneNumber,
        "fcmToken": event.user.fcmToken,
        "otp": event.user.otpCode,
        "otpId": event.user.otpId,
      });

      final token = await authService.getToken();
      await _storage.write(key: 'AuthToken', value: token);

      emit(SignUpSuccess(message: "Registration Successful!"));
      emit(Authenticated(token: token!));
    } on SocketException {
      emit(ConnectionError(message: "No internet connection"));
    } catch (e) {
      if (e is AuthException) {
        emit(AuthError(message: e.message));
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final responseData =
          await authRepository.login(event.phoneNumber, event.password);

      final token = responseData['AuthToken'];
      final expiresAt = responseData['expiresAt'];

      _storage.write(key: 'AuthToken', value: token);
      await _storage.write(key: 'expires_at', value: expiresAt);

      emit(Authenticated(token: token));
    } on SocketException {
      emit(ConnectionError(message: "No internet connection"));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _storage.delete(key: 'auth_token');
    try {
      await _storage.deleteAll();
      emit(LogOutSucess());
    } catch (e) {
      emit(LogOutError(message: e.toString()));
    }
  }
}
