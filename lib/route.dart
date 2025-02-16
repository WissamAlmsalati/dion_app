import 'package:dion_app/features/home_screen/presentation/screens/home_screen.dart';
import 'package:dion_app/features/profile_feature/presentatioon/screens/profile_screen.dart';
import 'package:dion_app/features/reset_password/presentation/screens/phone_number_screen.dart';
import 'package:dion_app/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dion_app/features/authintication_feature/presentation/screens/login_screen.dart';
import 'package:dion_app/features/authintication_feature/presentation/screens/phone_number_verify.dart';
import 'package:dion_app/features/authintication_feature/presentation/screens/sign_up_screen.dart';
import 'package:dion_app/features/authintication_feature/presentation/screens/verify_otp.dart';
import 'package:dion_app/features/main_screens/views/screens/main_screen.dart';
import 'package:dion_app/features/authintication_feature/presentation/authintication_bloc/auth_bloc.dart';

class RouterConfig {
  // Route names as constants for better maintainability
  static const String home = '/';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String mainScreen = '/main_screen';
  static const String homeScreen = '/home_screen';
  static const String otp = '/otp';
  static const String resetPassPhone = '/reset_pass_phone_screen';
  static const String resetPassOtp = '/reset_pass_otp_screen';
  static const String profile = '/profile_screen';

  // List of public routes that don't require authentication
  static const List<String> publicRoutes = [
    login,
    signup,
    otp,
    resetPassPhone,
    resetPassOtp,
  ];

  // Router configuration
  static final router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: _errorBuilder,
    redirect: _guardRoute,
  );

  // Routes definition
  static final List<RouteBase> _routes = [
    GoRoute(
      path: home,
      builder: (context, state) => VerifyPhoneNumber(),
    ),
    GoRoute(
      path: signup,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SignUpScreen(
          phoneNumber: extra?['phoneNumber'] as String? ?? '',
          otp: extra?['otp'] as int? ?? 0,
          expiresAt: extra?['expiresAt'] as String? ?? '',
        );
      },
    ),
    // Updated Login route to extract and pass the 'redirect' query parameter:
    GoRoute(
      path: login,
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return LoginScreen(redirect: redirect);
      },
    ),
    GoRoute(
      path: mainScreen,
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: homeScreen,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: otp,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OtpScreen(
          phoneNumber: extra?['phoneNumber'] as String? ?? '',
          otp: extra?['otp'] as int? ?? 0,
          expiresAt: extra?['expiresAt'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: resetPassPhone,
      builder: (context, state) => PhoneNumberScreen(),
    ),
    GoRoute(
      path: resetPassOtp,
      builder: (context, state) {
        final extra = state.extra;
        String phoneNumber = '';

        if (extra is Map<String, dynamic> && extra.containsKey('phoneNumber')) {
          phoneNumber = extra['phoneNumber'] as String? ?? '';
        }

        return ResetPasswordScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      name: 'profile',
      path: profile,
      builder: (context, state) => ProfileScreen(),
    ),
  ];

  // Error screen builder
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    );
  }

  // Route guard
  static String? _guardRoute(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthenticationBloc>().state;
    final isProfileRoute = state.matchedLocation == profile;

    // If the user is trying to access the profile route
    if (isProfileRoute) {
      if (authState is Authenticated) {
        // Allow access if authenticated
        return null;
      } else if (authState is Unauthenticated) {
        // Redirect to login with a "redirect" query parameter pointing to profile
        return '$login?redirect=$profile';
      }
    }

    // Handle other routes: if authenticated and at home, go to mainScreen
    if (authState is Authenticated && state.matchedLocation == home) {
      return mainScreen;
    } else if (authState is Unauthenticated &&
        !publicRoutes.contains(state.matchedLocation)) {
      return home;
    }

    return null;
  }

  // Helper method to extract parameters from state (if needed)
  static Map<String, dynamic> _extractParams(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    return {
      'phoneNumber': extra?['phoneNumber'] as String? ?? '',
      'otp': extra?['otp'] as int? ?? 0,
      'expiresAt': extra?['expiresAt'] as String? ?? '',
    };
  }
}
