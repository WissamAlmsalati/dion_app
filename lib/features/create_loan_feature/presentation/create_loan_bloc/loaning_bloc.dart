import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/loaning_model.dart';
import '../../domain/repository/create_loan_repository.dart';
import 'loaning_event.dart';
import 'loaning_state.dart';



import 'package:flutter_bloc/flutter_bloc.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final CreateLoanRepository createLoanRepository;

  CreateLoanBloc({required this.createLoanRepository}) : super(CreateLoanInitial()) {
    on<CreateLoan>(_onCreateLoan);
  }

  Future<void> _onCreateLoan(CreateLoan event, Emitter<CreateLoanState> emit) async {
    emit(CreateLoanLoading());
    try {
      await createLoanRepository.createLoan(event.loaningModel);
      emit(CreateLoanCreated());
    } catch (e) {
      emit(CreateLoanError(message: e.toString()));
    }
  }

}