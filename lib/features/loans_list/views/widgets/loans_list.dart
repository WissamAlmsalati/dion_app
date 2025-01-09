import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/loan.dart';
import '../../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import '../loan_detail.dart';

class LoanListItem extends StatelessWidget {
  final Loan loan;

  const LoanListItem({Key? key, required this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
