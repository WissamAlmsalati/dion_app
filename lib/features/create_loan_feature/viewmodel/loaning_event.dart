import 'package:equatable/equatable.dart';
import '../models/loaning_model.dart';

abstract class CreateLoanEvent extends Equatable {
  const CreateLoanEvent();

  @override
  List<Object> get props => [];
}

class CreateLoan extends CreateLoanEvent {
  final LoaningModel loaningModel;

  const CreateLoan({required this.loaningModel});

  @override
  List<Object> get props => [loaningModel];
}