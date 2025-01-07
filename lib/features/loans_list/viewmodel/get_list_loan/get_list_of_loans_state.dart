part of 'get_list_of_loans_bloc.dart';



abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object?> get props => [];
}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanLoadingMore extends LoanState {}

class LoanLoaded extends LoanState {
  final List<Loan> loans;

  const LoanLoaded(this.loans);

  @override
  List<Object?> get props => [loans];
}

class LoanError extends LoanState {
  final String message;

  const LoanError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoanEndOfList extends LoanState {
  final List<Loan> loans;

  const LoanEndOfList(this.loans);

  @override
  List<Object?> get props => [loans];
}