
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dion_app/features/authintication_feature/viewmodel/auth_bloc.dart';
import 'package:dion_app/features/home_screen/viewmodel/loaning_bloc.dart';
import 'package:dion_app/features/loand_detail_feature/blocs/debt_repayment/settle_loan_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_bloc.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_cubit.dart';
import 'package:dion_app/features/authintication_feature/repository/auth_repository.dart';
import 'package:dion_app/features/home_screen/repository/loaning_repository.dart';
import 'package:dion_app/features/loans_list/domain/repostry/settling_reposotory.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';
import 'package:dion_app/features/reset_password/domain/reset_password_impl.dart';
import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';
import 'package:get_it/get_it.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استرجاع الـ GetIt instance مباشرةً عبر GetIt.instance أو getIt
    final getIt = GetIt.instance;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            authRepository: getIt<AuthRepository>(),
          )..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => SettleLoanBloc(
            settlingRepository: getIt<SettlingRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => LoanBloc(
            loanRepository: getIt<LoanRepository>(),
          )..add(const LoadLoans(loanType: '')),
        ),
        BlocProvider(
          create: (context) => LoaningBloc(
            repository: getIt<LoaningRepository>(),
          )..add(FetchLoaningData()),
        ),
        BlocProvider(
          create: (context) => ResetPasswordCubit(
            getIt<ResetPasswordImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            profileDataRepostryImpl: getIt<ProfileDataRepostryImpl>(),
          )..fetchProfileData(),
        ),
      ],
      child: child,
    );
  }
}
