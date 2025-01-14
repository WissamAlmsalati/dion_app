import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/authintication_feature/services/auth_service.dart';
import 'features/authintication_feature/viewmodel/auth_bloc.dart';
import 'features/home_screen/viewmodel/loaning_bloc.dart';
import 'features/loaning_feature/repository/loaning_repository.dart';
import 'features/settling_feature/reposittory/settling_reposotory.dart';
import 'features/settling_feature/viewmodel/settle_loan_bloc.dart';
import 'features/loans_list/repostry/loans_repostry.dart';
import 'features/loans_list/viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import 'route.dart';

void main() {
  final AuthService authService = AuthService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final loaningRepository = LoaningRepository(authService: authService);

  runApp(MyApp(
      authService: authService,
      storage: secureStorage,
      loaningRepository: loaningRepository));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final FlutterSecureStorage storage;
  final LoaningRepository loaningRepository;

  const MyApp({
    required this.authService,
    required this.storage,
    required this.loaningRepository,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => SettleLoanBloc(
            settlingRepository: SettlingRepository(authService: authService),
          ),
        ),
        BlocProvider(
          create: (context) => LoanBloc(
            loanRepository: LoanRepository(authService: authService),
          )..add(LoadLoans()),
        ),
        BlocProvider(
          create: (context) => LoaningBloc()..add(FetchLoaningData()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Authentication App',
        theme: AppTheme.purpleTheme,
        routerConfig: AppRouter.router,
        locale: const Locale('ar', 'AE'), // Arabic locale
        supportedLocales: const [Locale('ar', 'AE')], // Supported locales
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // Enforce RTL layout
            child: BlocBuilder<AuthenticationBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  AppRouter.router.go('/main_screen');
                } else if (state is Unauthenticated) {
                  AppRouter.router.go('/');
                } else if (state is AuthLoading ) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
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
