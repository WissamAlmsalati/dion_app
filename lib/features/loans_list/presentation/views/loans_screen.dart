import 'package:dion_app/features/loans_list/presentation/widgets/loans_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dion_app/features/loans_list/presentation/widgets/loan_item.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/loans_list.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/auth_service.dart';
import '../../../authintication_feature/presentation/authintication_bloc/auth_bloc.dart';
import '../../../loand_detail_feature/presentation/blocs/debt_repayment/settle_loan_bloc.dart';
import '../../domain/repostry/loans_repostry.dart';
import '../get_list_loan/get_list_of_loans_bloc.dart';

class LoanListScreen extends StatelessWidget {
  const LoanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Borrowing and Lending
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('الديون'),
          centerTitle: true,
          bottom:  TabBar(
              labelStyle: GoogleFonts.tajawal(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'الديون المقرضة'),
              Tab(text: 'الديون المقترضة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildLoanTab(context, loanType: "Borrowing"),
            buildLoanTab(context, loanType: "Lending"),
          ],
        ),
      ),
    );
  }

  
}
