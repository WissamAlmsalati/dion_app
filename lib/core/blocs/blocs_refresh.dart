import 'package:dion_app/features/home_screen/viewmodel/loaning_bloc.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Adjust these import paths to match your project structure.
import 'package:dion_app/features/authintication_feature/viewmodel/auth_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';

class BlocsRefresher extends StatelessWidget {
  final Widget child;

  const BlocsRefresher({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.read<LoanBloc>().add(const LoadLoans(page: 1, loanType: 'Borrowing'));
              context.read<LoanBloc>().add(const LoadLoans(page: 1, loanType: 'Lending'));
              context.read<ProfileCubit>().fetchProfileData();
              context.read<LoaningBloc>().add(FetchLoaningData());
            }else if (state is Unauthenticated) {
             
            }
          },
        ),
      ],
      child: child,
    );
  }
}
