import 'package:dion_app/features/loans_list/models/loan.dart';
import 'package:dion_app/features/loans_list/presentation/loan_update_status/update_loan_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateLoanStatusWidget extends StatelessWidget {
  const UpdateLoanStatusWidget({
    super.key,
    required this.loan,
    required this.loanType,
  });

  final String loanType;
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanStatusBloc, LoanStatusState>(
      listener: (context, state) {
        if (state is LoanStatusFailure) {
          // Show an error message from the server in a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, statusState) {
        // When the bloc is loading, show a progress indicator.
        if (statusState is LoanStatusLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        // If the loan is in "Waiting" status and the bloc is in its initial state,
        // display the Accept/Reject buttons.
        if (loanType == "Borrowing" &&
            loan.loanStatus == "Waiting" &&
            statusState is LoanStatusInitial) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<LoanStatusBloc>().add(
                        UpdateLoanStatus(loanId: loan.id, loanStatus: 1),
                      );
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
                        UpdateLoanStatus(loanId: loan.id, loanStatus: 2),
                      );
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
            ],
          );
        }

        // Show success messages based on the updated loan status.
        if (statusState is LoanStatusSuccess && loan.loanStatus == 1) {
          return const Text(
            'تم قبول القرض بنجاح!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (statusState is LoanStatusSuccess && loan.loanStatus == 2) {
          return const Text(
            'تم رفض القرض بنجاح!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return Container();
      },
    );
  }
}
