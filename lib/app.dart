import 'package:dion_app/core/services/providers.dart';
import 'package:dion_app/core/theme/app_theme.dart';
import 'package:dion_app/features/authintication_feature/presentation/authintication_bloc/auth_bloc.dart';
import 'package:dion_app/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dion_app/core/services/auth_token_service.dart';

class MyApp extends StatelessWidget {

  final AuthService authService = GetIt.instance<AuthService>();
  final FlutterSecureStorage storage = GetIt.instance<FlutterSecureStorage>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dion App',
        theme: AppTheme.purpleTheme,
        routerConfig: AppRouter.router,
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
            child: BlocBuilder<AuthenticationBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthChecking) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is Authenticated) {
                  AppRouter.router.go('/main_screen');
                } else if (state is Unauthenticated) {
                  AppRouter.router.go('/');
                }
                return child!;
              },
            ),
          );
        },
      ),
    );
  }
}
