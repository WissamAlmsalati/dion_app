import 'package:dion_app/core/widgets/build_row_contect.dart';
import 'package:dion_app/features/loans_list/domain/repostry/accept_loan_repository.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/update_loan_status_widget.dart';
import 'package:dion_app/features/loans_list/presentation/loan_update_status/update_loan_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loan_detail_repository_impl.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_event.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_state.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loadType;
  final int loanId;

  const LoanDetailScreen({super.key, required this.loanId, required this.loadType});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoanDetailBloc(
            repository: LoanDetailRepositoryImpl(dio: dio),
          )..add(LoadLoanDetail(loanId: loanId)),
        ),
        BlocProvider(
          create: (context) => LoanStatusBloc(
            acceptLoanRepository: AcceptLoanRepository(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل القرض', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<LoanDetailBloc, LoanDetailState>(
          builder: (context, state) {
            if (state is LoanDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoanDetailLoaded) {
              final loan = state.loan;
              String loanStatusText = loan.loanStatus == "Waiting"
                  ? "في انتظار القبول"
                  : loan.loanStatus == "Approved"
                      ? "تم قبول القرض"
                      : loan.loanStatus == "Rejected"
                          ? "تم رفض القرض"
                          : "تم التسوية";

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDetailItem('اسم المدين', loan.deptName ?? 'غير متوفر'),
                      buildDetailItem('الهاتف', loan.phoneNumber ?? 'غير متوفر'),
                      buildDetailItem(
                        'المبلغ',
                        '\$${loan.amount?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      buildDetailItem(
                        'المبلغ المسترد',
                        '\$${loan.refundAmount?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      buildDetailItem(
                        'تاريخ الاستحقاق',
                        loan.dueDate?.toLocal().toString().split(' ')[0] ?? 'غير متوفر',
                      ),
                      buildDetailItem('حالة القرض', loanStatusText),
                       buildDetailItem("نوع القرض", loadType),
                      const SizedBox(height: 20),
                      UpdateLoanStatusWidget(loan: loan, loanType: loadType),

                      
                    ],
                  ),
                ),
              );
            } else if (state is LoanDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}