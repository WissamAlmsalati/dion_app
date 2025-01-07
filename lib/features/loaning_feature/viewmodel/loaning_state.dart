import 'package:equatable/equatable.dart';

abstract class CreateLoanState extends Equatable {
  const CreateLoanState();

  @override
  List<Object> get props => [];
}

class CreateLoanInitial extends CreateLoanState {}

class CreateLoanLoading extends CreateLoanState {}

class CreateLoanCreated extends CreateLoanState {}

class CreateLoanError extends CreateLoanState {
  final String message;

  const CreateLoanError({required this.message});

  @override
  List<Object> get props => [message];
}