import 'package:dion_app/features/loans_list/presentation/widgets/loans_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/loan.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';
import 'package:dion_app/features/loans_list/viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/loans_list.dart';

class LoanTabsScreen extends StatelessWidget {
  const LoanTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate the AuthService once and pass it to each repository.
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
              child: const LoanListView(),
            ),
            // Second Tab: Lending Loans
            BlocProvider(
              create: (context) => LoanBloc(
                loanRepository: LoanRepository(authService: authService),
              )..add(const LoadLoans(page: 1, loanType: 'Lending')),
              child: const LoanListView(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple widget that builds the loan list based on the Bloc state.
class LoanListView extends StatelessWidget {
  const LoanListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        if (state is LoanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoanLoaded) {
          return LoanList(loans: state.loans);
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




class LoanList extends StatelessWidget {
  final List<Loan> loans;

  const LoanList({Key? key, required this.loans}) : super(key: key);

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
        return LoanListItem(loan: loan);
      },
    );
  }
}

