part of 'loaning_bloc.dart';


@immutable
abstract class LoaningState {}

class LoaningInitial extends LoaningState {}

class LoaningLoading extends LoaningState {}

class LoaningLoaded extends LoaningState {
  final LoaningData loaningData;
  LoaningLoaded(this.loaningData);
}

class LoaningError extends LoaningState {
  final String message;
  LoaningError(this.message);
}