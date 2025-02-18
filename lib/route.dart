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
  static const String home = '/';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String mainScreen = '/main_screen';
  static const String homeScreen = '/home_screen';
  static const String otp = '/otp';
  static const String resetPassPhone = '/reset_pass_phone_screen';
  static const String resetPassOtp = '/reset_pass_otp_screen';
  static const String profile = '/profile_screen';

  static const List<String> publicRoutes = [
    login,
    signup,
    otp,
    resetPassPhone,
    resetPassOtp,
  ];

  static final router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: _errorBuilder,
    redirect: _guardRoute,
  );

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
    GoRoute(
      path: login,
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return LoginScreen(redirect: redirect);
      },
    ),
    GoRoute(
      path: mainScreen,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: homeScreen,
      builder: (context, state) => const HomeScreen(),
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
      builder: (context, state) => const ProfileScreen(),
    ),
  ];

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    );
  }

  static String? _guardRoute(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthenticationBloc>().state;

    // إذا لم يكن المستخدم مسجلاً الدخول وأراد فتح صفحة غير عامة،
    // أعد توجيهه إلى صفحة تسجيل الدخول مع إعادة توجيه إلى الصفحة المطلوبة بعد تسجيل الدخول
    final bool isPublicRoute = publicRoutes.contains(state.matchedLocation);
    if (authState is Unauthenticated && !isPublicRoute) {
      return '$login?redirect=${state.matchedLocation}';
    }

    // إذا كان المستخدم مسجلاً الدخول وهو في الصفحة الرئيسية، أعد توجيهه إلى الصفحة الرئيسية بعد تسجيل الدخول
    if (authState is Authenticated && state.matchedLocation == home) {
      return mainScreen;
    }

    // السماح بالانتقال للصفحة المطلوبة إذا لم يكن هناك شرط لإعادة التوجيه
    return null;
  }

  static Map<String, dynamic> _extractParams(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    return {
      'phoneNumber': extra?['phoneNumber'] as String? ?? '',
      'otp': extra?['otp'] as int? ?? 0,
      'expiresAt': extra?['expiresAt'] as String? ?? '',
    };
  }
}