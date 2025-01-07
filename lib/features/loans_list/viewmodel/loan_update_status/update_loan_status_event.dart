part of 'update_loan_status_bloc.dart';


abstract class LoanStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateLoanStatus extends LoanStatusEvent {
  final int loanId;
  final int loanStatus;

  UpdateLoanStatus({required this.loanId, required this.loanStatus});

  @override
  List<Object?> get props => [loanId, loanStatus];
}
