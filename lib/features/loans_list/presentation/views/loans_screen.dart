import 'package:dion_app/features/loans_list/presentation/widgets/loans_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dion_app/features/loans_list/presentation/widgets/loan_item.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/loans_list.dart';

import '../../../authintication_feature/services/auth_service.dart';
import '../../../authintication_feature/viewmodel/auth_bloc.dart';
import '../../../settling_feature/reposittory/settling_reposotory.dart';
import '../../../settling_feature/viewmodel/settle_loan_bloc.dart';
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
          title: const Text('الديون'),
          centerTitle: true,
          bottom: const TabBar(
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
