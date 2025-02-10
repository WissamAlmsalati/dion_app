import 'package:dion_app/features/loans_list/domain/repostry/accept_loan_repository.dart';
import 'package:dion_app/features/loans_list/viewmodel/loan_update_status/update_loan_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:dion_app/features/loans_list/domain/repostry/loan_detail_repository_impl.dart';
import 'package:dion_app/features/loans_list/models/loan.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_event.dart';
import 'package:dion_app/features/loans_list/presentation/bloc/loan_detail_state.dart';

class LoanDetailScreen extends StatelessWidget {
  final int loanId;

  const LoanDetailScreen({Key? key, required this.loanId}) : super(key: key);

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
          create: (context) => LoanStatusBloc(acceptLoanRepository: AcceptLoanRepository()), // Provide LoanStatusBloc here
        ),
      ],
      child: LoanDetailView(),
    );
  }
}

class LoanDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return _buildLoanDetail(context, state.loan);
          } else if (state is LoanDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildLoanDetail(BuildContext context, Loan loan) {
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
            _buildDetailItem('اسم المدين', loan.deptName ?? 'غير متوفر'),
            _buildDetailItem('الهاتف', loan.phoneNumber ?? 'غير متوفر'),
            _buildDetailItem('المبلغ', '\$${loan.amount?.toStringAsFixed(2) ?? '0.00'}'),
            _buildDetailItem('المبلغ المسترد', '\$${loan.refundAmount?.toStringAsFixed(2) ?? '0.00'}'),
            _buildDetailItem('تاريخ الاستحقاق', loan.dueDate?.toLocal().toString().split(' ')[0] ?? 'غير متوفر'),
            _buildDetailItem('حالة القرض', loanStatusText),






//             BlocBuilder<LoanStatusBloc, LoanStatusState>(
//   builder: (context, state) {
//     print("Loan Status: ${loan.loanStatus}");  // Debugging
//     // print("Loan Creditor: ${loan.creditor?.name}");  // Debugging
//     print("Bloc State: $state");  // Debugging

//     if (loan.creditor != null && loan.loanStatus == 0 && state is LoanStatusInitial) {
//       return Row(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               print("Accept Button Pressed");
//               context.read<LoanStatusBloc>().add(UpdateLoanStatus(loanId: loan.id, loanStatus: 1));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               'قبول القرض',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               print("Reject Button Pressed");
//               context.read<LoanStatusBloc>().add(UpdateLoanStatus(loanId: loan.id, loanStatus: 2));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               'رفض القرض',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ],
//       );
//     } else if (state is LoanStatusLoading) {
//       return const CircularProgressIndicator(color: Colors.blue);
//     } else if (state is LoanStatusSuccess && loan.loanStatus == 1) {
//       return const Text(
//         'تم قبول القرض بنجاح!',
//         style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
//       );
//     } else if (state is LoanStatusSuccess && loan.loanStatus == 2) {
//       return const Text(
//         'تم رفض القرض بنجاح!',
//         style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
//       );
//     }
//     return Container();
//   },
// )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
