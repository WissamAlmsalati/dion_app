part of 'get_list_of_loans_bloc.dart';




@immutable
abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoans extends LoanEvent {
  final int page;

  const LoadLoans({this.page = 1});

  @override
  List<Object?> get props => [page];
}


class LoadLoanDetails extends LoanEvent {
  final int loanId;

  LoadLoanDetails(this.loanId);
}

class LoadMoreLoans extends LoanEvent {
  const LoadMoreLoans();
}


