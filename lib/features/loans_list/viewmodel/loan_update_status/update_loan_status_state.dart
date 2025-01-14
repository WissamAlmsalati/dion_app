part of 'update_loan_status_bloc.dart';

@immutable
abstract class LoanStatusState extends Equatable {
  const LoanStatusState();

  @override
  List<Object> get props => [];
}

class LoanStatusInitial extends LoanStatusState {}

class LoanStatusLoading extends LoanStatusState {}

class LoanStatusSuccess extends LoanStatusState {
  final String message;

  const LoanStatusSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class LoanStatusFailure extends LoanStatusState {
  final String error;

  const LoanStatusFailure({required this.error});

  @override
  List<Object> get props => [error];
}