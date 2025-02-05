import 'package:dion_app/features/reset_password/presentation/screens/phone_number_screen.dart';
import 'package:dion_app/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'features/authintication_feature/views/screens/login_screen.dart';
import 'features/authintication_feature/views/screens/phone_number_verify.dart';
import 'features/authintication_feature/views/screens/sign_up_screen.dart';
import 'features/authintication_feature/views/screens/verify_otp.dart';
import 'features/main_screens/views/screens/main_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return VerifyPhoneNumber();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phoneNumber = extra?['phoneNumber'] as String? ?? '';
          final otp = extra?['otp'] as int? ?? 0;
          final expiresAt = extra?['expiresAt'] as String? ?? '';
          return SignUpScreen(
            phoneNumber: phoneNumber,
            otp: otp,
            expiresAt: expiresAt,
          );
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: '/main_screen',
        builder: (BuildContext context, GoRouterState state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phoneNumber = extra?['phoneNumber'] as String? ?? '';
          final otp = extra?['otp'] as int? ?? 0;
          final expiresAt = extra?['expiresAt'] as String? ?? '';
          return OtpScreen(
            phoneNumber: phoneNumber,
            otp: otp,
            expiresAt: expiresAt,
          );
        },
      ),
      GoRoute(
        path: "/reset_pass_phone_screen",
        builder: (context, state) {
          return  PhoneNumberScreen();
        },
      ),
      GoRoute(
        path: "/reset_pass_otp_screen",
        builder: (context, state) {
          return ResetPasswordScreen(
         );
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Page not found')),
      );
    },
  );
}
