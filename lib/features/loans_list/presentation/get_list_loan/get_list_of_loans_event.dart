part of 'get_list_of_loans_bloc.dart';

abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoans extends LoanEvent {
  final int page;
  final String loanType; // New parameter to indicate type

  const LoadLoans({this.page = 1, required this.loanType});

  @override
  List<Object?> get props => [page, loanType];
}

class LoadLoanDetails extends LoanEvent {
  final int loanId;

  const LoadLoanDetails({required this.loanId});

  @override
  List<Object?> get props => [loanId];
}
