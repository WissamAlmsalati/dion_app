import 'package:flutter/material.dart';

import '../../models/loan.dart';
import 'loans_list.dart';

class LoanList extends StatelessWidget {
  final List<Loan> loans;

  const LoanList({Key? key, required this.loans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد ديون',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return LoanListItem(loan: loan);
      },
    );
  }
}
