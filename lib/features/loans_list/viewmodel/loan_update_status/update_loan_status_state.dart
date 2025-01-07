part of 'update_loan_status_bloc.dart';


abstract class LoanStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoanStatusInitial extends LoanStatusState {}

class LoanStatusLoading extends LoanStatusState {}

class LoanStatusSuccess extends LoanStatusState {}

class LoanStatusFailure extends LoanStatusState {
  final String error;

  LoanStatusFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
