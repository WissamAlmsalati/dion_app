import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authintication_feature/services/auth_service.dart';
import '../../settling_feature/reposittory/settling_reposotory.dart';
import '../../settling_feature/viewmodel/settle_loan_bloc.dart';
import '../models/loan.dart';
import '../viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import '../viewmodel/loan_update_status/update_loan_status_bloc.dart';

class LoanDetailScreen extends StatelessWidget {
  final Loan loan;

  const LoanDetailScreen({Key? key, required this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoanStatusBloc()),
        BlocProvider(create: (context) => SettleLoanBloc(settlingRepository: SettlingRepository(authService: AuthService()))),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SettleLoanBloc, SettleLoanState>(
            listener: (context, state) {
              if (state is SettleLoanSuccess) {
                context.read<LoanBloc>().add(const LoadLoans());
                Navigator.pop(context, true); // Pass true to indicate success
              }
            },
          ),
          BlocListener<LoanStatusBloc, LoanStatusState>(
            listener: (context, state) {
              if (state is LoanStatusSuccess) {
                context.read<LoanBloc>().add(const LoadLoans());
                Navigator.pop(context, true); // Pass true to indicate success
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              loan.deptName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('اسم المدين', loan.deptName),
                  _buildDetailItem('الهاتف', loan.phoneNumber),
                  _buildDetailItem('المبلغ', '\$${loan.amount.toStringAsFixed(2)}'),
                  _buildDetailItem('المبلغ المسترد', '\$${loan.refundAmount.toStringAsFixed(2)}'),
                  _buildDetailItem('تاريخ الاستحقاق', loan.dueDate.toLocal().toString().split(' ')[0]),
                  _buildDetailItem('ملاحظات', loan.notes),
                  _buildDetailItem('تاريخ التحديث', loan.updatedAt.toLocal().toString().split(' ')[0]),
                  _buildDetailItem(
                    loan.creditor != null ? 'الدائن' : 'المدين',
                    loan.creditor != null ? loan.creditor!.name : loan.debtor!.name,
                  ),
                  _buildDetailItem(
                    'حالة القرض',
                    loan.loanStatus == 0
                        ? "في انتظار القبول"
                        : loan.loanStatus == 1
                            ? "تم قبول القرض"
                            : loan.loanStatus == 2
                                ? "تم رفض القرض"
                                : "تم التسوية",
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<LoanStatusBloc, LoanStatusState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          if (loan.creditor != null &&
                              loan.loanStatus == 0 &&
                              state is LoanStatusInitial) ...[
                            ElevatedButton(
                              onPressed: () {
                                context.read<LoanStatusBloc>().add(
                                    UpdateLoanStatus(loanId: loan.id, loanStatus: 1));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'قبول القرض',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                context.read<LoanStatusBloc>().add(
                                    UpdateLoanStatus(loanId: loan.id, loanStatus: 2));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'رفض القرض',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ] else if (state is LoanStatusLoading) ...[
                            const CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ] else if (state is LoanStatusSuccess && loan.loanStatus == 1) ...[
                            const Text(
                              'تم قبول القرض بنجاح!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else if (state is LoanStatusSuccess && loan.loanStatus == 2) ...[
                            const Text(
                              'تم رفض القرض بنجاح!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else if (loan.creditor == null && loan.loanStatus == 1) ...[
                            BlocBuilder<SettleLoanBloc, SettleLoanState>(
                              builder: (context, state) {
                                if (state is SettleLoanLoading) {
                                  return const CircularProgressIndicator(
                                    color: Colors.blue,
                                  );
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    _showSettleDialog(context, loan.id, loan.amount - loan.refundAmount, () {
                                      context.read<LoanBloc>().add(const LoadLoans());
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

void _showSettleDialog(BuildContext context, int loanId, double maxAmount, VoidCallback onSettleSuccess) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تمت تسوية القرض بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
              onSettleSuccess(); // Call the callback to refresh the data
              Navigator.pop(context, true); // Close dialog on success and pass result
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
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                        return TextField(
                          controller: amountController,
                          decoration: InputDecoration(
                            hintText: 'أدخل المبلغ',
                            errorText: errorMessage,
                          ),
                          keyboardType: TextInputType.number,
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  BlocBuilder<SettleLoanBloc, SettleLoanState>(
                    builder: (context, state) {
                      if (state is SettleLoanLoading) {
                        return const SizedBox.shrink(); // Hide buttons when loading
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog without action
                            },
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              final amount = double.tryParse(amountController.text) ?? 0.0;
                              if (amount > 0 && amount <= maxAmount) {
                                context.read<SettleLoanBloc>().add(
                                    SettleLoan(loanId: loanId, amount: amount));
                              } else {
                                setState(() {
                                  errorMessage = 'القيمة المتبقية من الدين هي ${maxAmount.toStringAsFixed(2)}';
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
      // Refresh the screen when dialog closes with success
      onSettleSuccess();
    }
  });
}