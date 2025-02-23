import 'package:dion_app/core/widgets/build_row_contect.dart';
import 'package:dion_app/core/services/auth_token_service.dart';
import 'package:dion_app/features/loans_list/domain/repostry/accept_loan_repository.dart';
import 'package:dion_app/features/loans_list/domain/repostry/settling_reposotory.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/debt_repayment/settle_loan_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/get_list_loan/get_list_of_loans_bloc.dart';
import 'package:dion_app/features/loans_list/presentation/widgets/update_loan_status_widget.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_update_status/update_loan_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loan_detail_repository_impl.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_detail_bloc/loan_detail_bloc.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_detail_bloc/loan_detail_event.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_detail_bloc/loan_detail_state.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loadType;
  final int loanId;

  const LoanDetailScreen({Key? key, required this.loanId, required this.loadType})
      : super(key: key);

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
        BlocProvider(
          create: (context) => SettleLoanBloc(
            settlingRepository: SettlingRepository(authService: AuthService()),
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
        // Wrap the body in a RefreshIndicator for pull-to-refresh.
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<LoanDetailBloc>().add(LoadLoanDetail(loanId: loanId));
            // Optional: add a slight delay if needed.
            await Future.delayed(const Duration(seconds: 1));
          },
          // Ensure that the scroll view always allows overscrolling.
          child: BlocBuilder<LoanDetailBloc, LoanDetailState>(
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetailItem('اسم القرض', loan.deptName ?? 'غير متوفر'),
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
                          loan.dueDate?.toLocal().toString().split(' ')[0] ??
                              'غير متوفر',
                        ),
                        buildDetailItem('حالة القرض', loanStatusText),
                        buildDetailItem("نوع القرض", loadType),
                        const SizedBox(height: 20),
                        // This widget also refreshes the details on success.
                        UpdateLoanStatusWidget(loan: loan, loanType: loadType),
                        const SizedBox(height: 20),
                        if (loan.loanStatus == "Approved" && loadType == "Borrowing")
                          BlocBuilder<SettleLoanBloc, SettleLoanState>(
                            builder: (context, settleState) {
                              if (settleState is SettleLoanLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.blue),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  _showSettleDialog(
                                    context,
                                    loan.id,
                                    loan.amount - loan.refundAmount,
                                    () {
                                      // Refresh loan details after settling.
                                      context
                                          .read<LoanDetailBloc>()
                                          .add(LoadLoanDetail(loanId: loanId));
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'تسوية القرض',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
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
      ),
    );
  }

  /// Helper method to build a detail row.
  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettleDialog(
  BuildContext context,
  int loanId,
  double maxAmount,
  VoidCallback onSettleSuccess,
) {
  final TextEditingController amountController = TextEditingController();
  String? errorMessage;

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: BlocProvider.of<SettleLoanBloc>(context),
        child: BlocListener<SettleLoanBloc, SettleLoanState>(
          listener: (context, state) {
            if (state is SettleLoanSuccess) {
              // Display the message returned from the server.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              onSettleSuccess();
              Navigator.pop(context, true);
            } else if (state is SettleLoanFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل في تسوية القرض: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('تسوية القرض'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<SettleLoanBloc, SettleLoanState>(
                      builder: (context, state) {
                        if (state is SettleLoanLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.blue),
                          );
                        }
                        return TextField(
                          controller: amountController,
                          decoration: InputDecoration(
                            hintText: 'أدخل المبلغ',
                            errorText: errorMessage,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  BlocBuilder<SettleLoanBloc, SettleLoanState>(
                    builder: (context, state) {
                      if (state is SettleLoanLoading) {
                        return const SizedBox.shrink();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              final amount = double.tryParse(amountController.text) ?? 0.0;
                              if (amount > 0 && amount <= maxAmount) {
                                context.read<SettleLoanBloc>().add(
                                      SettleLoan(loanId: loanId, amount: amount),
                                    );
                              } else {
                                setState(() {
                                  errorMessage =
                                      'القيمة المتبقية من الدين هي ${maxAmount.toStringAsFixed(2)}';
                                });
                              }
                            },
                            child: const Text('تسوية'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  ).then((result) {
    if (result == true) {
      onSettleSuccess();
    }
  });
}

}
