import 'package:dion_app/features/loand_detail_feature/loan_update_status/update_loan_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your authentication and repository classes.
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';

// Import your Bloc, events, and states.
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/loans_list/data/models/loan.dart';

// Import your LoanListItem widget.
import 'package:dion_app/features/loans_list/presentation/widgets/loan_item.dart';

class LoanTabsScreen extends StatelessWidget {
  const LoanTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the AuthService instance.
    final authService = AuthService();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الديون'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Borrowing'),
              Tab(text: 'Lending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Borrowing Loans
            BlocProvider(
              create: (context) => LoanBloc(
                loanRepository: LoanRepository(authService: authService),
              )..add(const LoadLoans(page: 1, loanType: 'Borrowing')),
              child: const LoanListView(loanType: 'Borrowing'),
            ),
            // Second Tab: Lending Loans
            BlocProvider(
              create: (context) => LoanBloc(
                loanRepository: LoanRepository(authService: authService),
              )..add(const LoadLoans(page: 1, loanType: 'Lending')),
              child: const LoanListView(loanType: 'Lending'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanListView extends StatelessWidget {
  final String loanType;
  const LoanListView({Key? key, required this.loanType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanStatusBloc, LoanStatusState>(
      listener: (context, statusState) {
        if (statusState is LoanStatusSuccess) {
          // When the loan status is updated successfully, refresh the loan list.
          print("LoanStatusSuccess: ${statusState.message}");
          context.read<LoanBloc>().add(LoadLoans(page: 1, loanType: loanType));
        } else if (statusState is LoanStatusFailure) {
          print("LoanStatusFailure: ${statusState.error}");
        }
      },
      // The builder for LoanStatusBloc isn’t used to build UI directly;
      // instead, we delegate the UI to the LoanBloc consumer.
      builder: (context, statusState) {
        return BlocConsumer<LoanBloc, LoanState>(
          // Optionally, add a listener here if you need to handle side-effects from LoanBloc.
          listener: (context, loanState) {
            // For example, you could show a SnackBar if needed.
          },
          builder: (context, state) {
            if (state is LoanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoanLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Reload loans on pull-to-refresh.
                  context
                      .read<LoanBloc>()
                      .add(LoadLoans(page: 1, loanType: loanType));
                  // Optionally, wait for a moment to show the refresh indicator.
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: LoanList(loans: state.loans, loanType: loanType),
              );
            } else if (state is LoanError) {
              return Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}


class LoanList extends StatelessWidget {
  final List<Loan> loans;
  final String loanType;
  const LoanList({Key? key, required this.loans, required this.loanType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) {
      return Center(
        child: Text(
          'لا توجد ديون',
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: loans.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final loan = loans[index];
        return LoanListItem(
          loan: loan,
          loadType: loanType, // Passing the loan type here.
        );
      },
    );
  }
}
