import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authintication_feature/viewmodel/auth_bloc.dart';
import '../../settling_feature/reposittory/settling_reposotory.dart';
import '../../settling_feature/viewmodel/settle_loan_bloc.dart';
import '../models/loan.dart';
import '../repostry/loans_repostry.dart';
import '../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import '../viewmodel/loan_update_status/update_loan_status_bloc.dart';
import 'loan_detail.dart';

class LoanListScreen extends StatelessWidget {
  LoanListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الديون',
        ),
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
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              } else if (state is LoanLoaded) {
                final loans = state.loans;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        title: Text(
                          loan.deptName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        subtitle: Text(
                          'القيمة: ${loan.amount.toStringAsFixed(2)}\د.ل',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<LoanBloc>(context),
                                child: LoanDetailScreen(loan: loan),
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              context.read<LoanBloc>().add(const LoadLoans());
                            }
                          });
                        },
                      ),
                    );
                  },
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
      ),
    );
  }
}