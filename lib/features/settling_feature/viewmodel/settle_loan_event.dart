part of 'settle_loan_bloc.dart';




abstract class SettleLoanEvent extends Equatable {
  const SettleLoanEvent();

  @override
  List<Object> get props => [];
}

class SettleLoan extends SettleLoanEvent {
  final int loanId;
  final double amount;

  const SettleLoan({required this.loanId, required this.amount});

  @override
  List<Object> get props => [loanId, amount];
}

class AcceptLoan extends SettleLoanEvent {
  final int loanId;
  final int status;

  const AcceptLoan({required this.loanId, required this.status});

  @override
  List<Object> get props => [loanId, status];
}

class RejectLoan extends SettleLoanEvent {
  final int loanId;
  final int status;

  const RejectLoan({required this.loanId, required this.status});

  @override
  List<Object> get props => [loanId, status];
}