import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/loan.dart';
import '../../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import '../views/loan_detail.dart';

class LoanListItem extends StatelessWidget {
  final Loan loan;

  const LoanListItem({Key? key, required this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
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
          AuthService authService = AuthService();
          final token = await authService.getToken();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: BlocProvider.of<LoanBloc>(context),
                child: LoanDetailScreen(loanId: loan.id),
              ),
            ),
          ).then((result) {
            if (result == true) {
              context.read<LoanBloc>().add(const LoadLoans(page: 1, loanType: 'Borrowing')); // Adjust if needed
            }
          });
        },
      ),
    );
  }
}
