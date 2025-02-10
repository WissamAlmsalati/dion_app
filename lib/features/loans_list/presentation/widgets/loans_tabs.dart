import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/authintication_feature/viewmodel/auth_bloc.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/loans_list.dart';
import 'package:dion_app/features/settling_feature/reposittory/settling_reposotory.dart';
import 'package:dion_app/features/settling_feature/viewmodel/settle_loan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildLoanTab(BuildContext context, {required String loanType}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoanBloc(
            loanRepository: LoanRepository(authService: AuthService()),
          )..add(LoadLoans(loanType: loanType)),
        ),
        BlocProvider(
          create: (_) => SettleLoanBloc(
            settlingRepository: SettlingRepository(authService: AuthService()),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // Refresh the loans list upon a successful loan settlement
          BlocListener<SettleLoanBloc, SettleLoanState>(
            listener: (context, state) {
              if (state is SettleLoanSuccess) {
                context.read<LoanBloc>().add(LoadLoans(loanType: loanType));
              }
            },
          ),
          // Show a loading dialog during authentication
          BlocListener<AuthenticationBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        child: BlocBuilder<LoanBloc, LoanState>(
          builder: (context, state) {
            if (state is LoanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoanLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LoanBloc>().add(LoadLoans(loanType: loanType));
                },
                child: LoanList(loans: state.loans, loanType: loanType,),
              );
            } else if (state is LoanError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade700,
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                '',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }