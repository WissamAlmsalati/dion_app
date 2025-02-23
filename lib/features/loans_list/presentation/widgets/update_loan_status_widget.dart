import 'package:dion_app/features/loans_list/data/models/loan.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_update_status/update_loan_status_bloc.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_detail_bloc/loan_detail_bloc.dart';
import 'package:dion_app/features/loand_detail_feature/presentation/blocs/loan_detail_bloc/loan_detail_event.dart';
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
          // Show error message in a red SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is LoanStatusSuccess) {
          // Show success message in a SnackBar.
          // Here we use the returned message to choose a color.
          final snackBarColor = state.message.contains("Rejected") ? Colors.red : Colors.green;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: snackBarColor,
            ),
          );
          // Refresh the loan details screen by dispatching a new load event.
          context.read<LoanDetailBloc>().add(LoadLoanDetail(loanId: loan.id));
        }
      },
      builder: (context, statusState) {
        if (statusState is LoanStatusLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        // Display Accept/Reject buttons only if the loan is in a "Waiting" state
        // and the bloc is in its initial state.
        if (loanType == "Lending" &&
            loan.loanStatus == "Waiting" &&
            statusState is LoanStatusInitial) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<LoanStatusBloc>().add(
                        UpdateLoanStatus(loanId: loan.id, loanStatus: "Approved"),
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
                        UpdateLoanStatus(loanId: loan.id, loanStatus: "Rejected"),
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

        // Optionally, you can show text if the status is already updated.
        if (statusState is LoanStatusSuccess && loan.loanStatus == "Approved") {
          return const Text(
            'تم قبول القرض بنجاح!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (statusState is LoanStatusSuccess && loan.loanStatus == "Rejected") {
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
