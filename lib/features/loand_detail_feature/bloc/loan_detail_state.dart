import '../../loans_list/data/models/loan.dart';

abstract class LoanDetailState {}

class LoanDetailInitial extends LoanDetailState {}

class LoanDetailLoading extends LoanDetailState {}

class LoanDetailLoaded extends LoanDetailState {
  final Loan loan;
  LoanDetailLoaded({required this.loan});
}

class LoanDetailError extends LoanDetailState {
  final String message;
  LoanDetailError({required this.message});
}
