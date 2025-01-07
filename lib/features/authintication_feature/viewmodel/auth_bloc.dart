import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for secure storage
import 'package:http/http.dart' as http;
import '../../../core/network/api_constants.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../services/auth_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Secure storage instance
  final AuthService authService;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  AuthenticationBloc({required this.authService}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SendOtpEvent>(_onSendOtp);
    on<SignUpEvent>(_onSignUp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }


  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
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
    final response = await http.get(
      Uri.parse("${ApiConstants.sendOtpEndpoint}${event.phoneNumber}"),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      emit(OtpSent());
    } else {
      emit(AuthError(message: "Failed to send OTP: ${response.reasonPhrase}"));
    }
  } catch (e) {
    emit(AuthError(message: "Error: ${e.toString()}"));
  }
}

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtpEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "otpCode": event.otpCode,
          "phoneNumber": event.phoneNumber,
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        emit(OtpVerified());
      } else {
        emit(AuthError(
            message: "Failed to verify OTP: ${response.reasonPhrase}"));
      }
    } catch (e) {
      emit(AuthError(message: "Error: ${e.toString()}"));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": event.user.name,
          "email": event.user.email,
          "password": event.user.password,
          "phoneNumber": event.user.phoneNumber,
          "fcmToken": event.user.fcmToken,
        }),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        await _storage.write(key: 'auth_token', value: token);

        emit(SignUpSuccess(message: "Registration Successful!"));
        emit(Authenticated(token: token));
      } else {
        // Handle non-200 responses
        try {
          // Attempt to parse the response as JSON
          final responseData = json.decode(response.body);
          final errorMessage = responseData['title'] ?? "Failed to register: ${response.reasonPhrase}";
          emit(AuthError(message: errorMessage));
        } catch (e) {
          // If parsing fails, treat the response as plain text
          final errorMessage = response.body;
          emit(AuthError(message: errorMessage));
        }
      }
    } catch (e) {
      print(e);
      emit(AuthError(message: "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "phoneNumber": event.phoneNumber,
          "password": event.password,
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['authToken'];
        print(
            "Token: $token");
        final expiresAt = responseData['expiresAt'];

        // Store the token and expiration date securely
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'expires_at', value: expiresAt);

        emit(Authenticated(token: token));
      } else {
        emit(AuthError(message: "Failed to login: ${response.reasonPhrase}"));
      }
    } catch (e) {
      emit(AuthError(message: "Error: ${e.toString()}"));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _storage.delete(key: 'auth_token');
    try{
      await _storage.deleteAll();
      emit(LogOutSucess());
    }catch(e){
      emit(LogOutError(message: "Error: ${e.toString()}"));
      print(e);

    }

  }
}
