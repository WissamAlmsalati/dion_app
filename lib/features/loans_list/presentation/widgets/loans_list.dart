import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your authentication and repository classes.
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';

// Import your Bloc, events, and states.
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/loans_list/models/loan.dart';

// Import your LoanListItem widget.
import 'package:dion_app/features/loans_list/presentation/widgets/loan_item.dart';

/// This screen shows two tabs, one for "Borrowing" and one for "Lending" loans.
class LoanTabsScreen extends StatelessWidget {
  const LoanTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate the AuthService once and pass it to the repository.
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

/// A widget that builds the loan list based on the Bloc state.
/// It receives the `loanType` parameter and passes it along to [LoanList].
class LoanListView extends StatelessWidget {
  final String loanType;
  const LoanListView({Key? key, required this.loanType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        if (state is LoanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoanLoaded) {
          return LoanList(loans: state.loans, loanType: loanType);
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
  }
}

/// A widget that builds a [ListView] of loans.
/// It passes the [loanType] down to each [LoanListItem].
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
