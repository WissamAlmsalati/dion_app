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
          final phoneNumber = state.extra as String;
          return SignUpScreen(phoneNumber: phoneNumber);
        },
      ),
      // GoRoute(
      //   path: '/home',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return HomeScreen();
      //   },
      // ),
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
          final phoneNumber = state.extra as String?; // Retrieve the phone number
          return OtpScreen(phoneNumber: phoneNumber ?? '');
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