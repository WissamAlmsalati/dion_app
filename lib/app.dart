import 'package:dion_app/features/authintication_feature/presentation/authintication_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dion_app/core/services/providers.dart';
import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// Alias the custom router import:
import 'package:dion_app/route.dart' as appRouter;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dion App',
        theme: AppTheme.purpleTheme,
        routerConfig: appRouter.RouterConfig.router,
        locale: const Locale('ar', 'AE'),
        supportedLocales: const [Locale('ar', 'AE')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AuthStateHandler(child: child),
          );
        },
      ),
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  final Widget? child;

  const AuthStateHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthChecking) {
          return const LoadingScreen();
        }
        return child!;
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
