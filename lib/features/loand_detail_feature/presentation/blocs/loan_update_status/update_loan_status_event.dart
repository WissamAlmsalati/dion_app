part of 'update_loan_status_bloc.dart';



@immutable
abstract class UpdateLoanStatusEvent extends Equatable {
  const UpdateLoanStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateLoanStatus extends UpdateLoanStatusEvent {
  final int loanId;
  final String loanStatus;

  const UpdateLoanStatus({required this.loanId, required this.loanStatus});

  @override
  List<Object> get props => [loanId, loanStatus];
}