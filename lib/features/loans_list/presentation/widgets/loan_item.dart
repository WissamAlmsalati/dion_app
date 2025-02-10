import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/loan.dart';
import '../views/loan_detail.dart';

class LoanListItem extends StatelessWidget {
  final String loadType;
  final Loan loan;

  const LoanListItem({super.key, required this.loan, required this.loadType});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      color: setColorByType(loan.loanStatus, Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey.shade100,
          child: Icon(
            Icons.monetization_on,
            color: Colors.blueGrey.shade800,
          ),
        ),
        title: Text(
          loan.deptName,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.blueGrey.shade900,
          ),
        ),
        subtitle: Text(
          'القيمة: ${loan.amount.toStringAsFixed(2)} د.ل',
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.blueGrey.shade700,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.blueGrey.shade700,
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoanDetailScreen(
                loanId: loan.id,
                loadType: loadType,
              ),
            ),
          );
        },
      ),
    );
  }

  Color setColorByType(String loanStatus, Color defaultColor) {
    switch (loanStatus) {
      case 'Approved':
        return Colors.green.shade100;
      case 'Rejected':
        return Colors.red.shade100;
      default:
        return defaultColor;
    }
  }
}
