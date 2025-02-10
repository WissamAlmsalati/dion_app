import 'package:dion_app/features/loans_list/presentation/widgets/loan_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authintication_feature/services/auth_service.dart';
import '../../../authintication_feature/viewmodel/auth_bloc.dart';
import '../../../settling_feature/reposittory/settling_reposotory.dart';
import '../../../settling_feature/viewmodel/settle_loan_bloc.dart';
import '../../models/loan.dart';
import '../../domain/repostry/loans_repostry.dart';
import '../../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import 'loan_detail.dart';

class LoanListScreen extends StatelessWidget {
  LoanListScreen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Borrowing and Lending
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الديون'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Borrowing'),
              Tab(text: 'Lending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab: Borrowing loans
            _buildLoanTab(context, loanType: "Borrowing"),
            // Second tab: Lending loans
            _buildLoanTab(context, loanType: "Lending"),
          ],
        ),
      ),
    );
  }

  /// Builds a tab view for a given [loanType]
  Widget _buildLoanTab(BuildContext context, {required String loanType}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoanBloc(
            loanRepository: LoanRepository(authService: AuthService()),
          )..add(LoadLoans(loanType: loanType)), // Pass the loanType parameter here
        ),
        BlocProvider(
          create: (_) => SettleLoanBloc(
            settlingRepository: SettlingRepository(authService: AuthService()),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SettleLoanBloc, SettleLoanState>(
            listener: (context, state) {
              if (state is SettleLoanSuccess) {
                // Reload the loans with the same loanType on success
                context.read<LoanBloc>().add(LoadLoans(loanType: loanType));
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
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LoanBloc>().add(LoadLoans(loanType: loanType));
                },
                child: LoanList(loans: state.loans),
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
