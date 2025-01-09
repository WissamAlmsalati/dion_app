import 'package:dion_app/features/loans_list/views/widgets/loan_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authintication_feature/services/auth_service.dart';
import '../../authintication_feature/viewmodel/auth_bloc.dart';
import '../../settling_feature/reposittory/settling_reposotory.dart';
import '../../settling_feature/viewmodel/settle_loan_bloc.dart';
import '../models/loan.dart';
import '../repostry/loans_repostry.dart';
import '../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import 'loan_detail.dart';

class LoanListScreen extends StatelessWidget {
  LoanListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الديون'),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoanBloc(loanRepository: LoanRepository(authService: AuthService()))
              ..add(const LoadLoans()),
          ),
          BlocProvider(
            create: (_) => SettleLoanBloc(settlingRepository: SettlingRepository(authService: AuthService())),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<SettleLoanBloc, SettleLoanState>(
              listener: (context, state) {
                if (state is SettleLoanSuccess) {
                  context.read<LoanBloc>().add(const LoadLoans());
                }
              },
            ),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoanLoaded) {
                return LoanList(loans: state.loans);
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}