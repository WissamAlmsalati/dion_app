part of 'settle_loan_bloc.dart';


abstract class SettleLoanState extends Equatable {
  const SettleLoanState();

  @override
  List<Object> get props => [];
}

class SettleLoanInitial extends SettleLoanState {}

class SettleLoanLoading extends SettleLoanState {}

class SettleLoanSuccess extends SettleLoanState {
  final String message;

  const SettleLoanSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class SettleLoanFailure extends SettleLoanState {
  final String error;

  const SettleLoanFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AcceptLoanLoading extends SettleLoanState {}

class AcceptLoanSuccess extends SettleLoanState {}

class RejectLoanLoading extends SettleLoanState {}

class RejectLoanSuccess extends SettleLoanState {}