import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/loaning_model.dart';
import '../repository/loaning_repository.dart';
import 'loaning_event.dart';
import 'loaning_state.dart';



import 'package:flutter_bloc/flutter_bloc.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final LoaningRepository loaningRepository;

  CreateLoanBloc({required this.loaningRepository}) : super(CreateLoanInitial()) {
    on<CreateLoan>(_onCreateLoan);
  }

  Future<void> _onCreateLoan(CreateLoan event, Emitter<CreateLoanState> emit) async {
    emit(CreateLoanLoading());
    try {
      await loaningRepository.createLoan(event.loaningModel);
      emit(CreateLoanCreated());
    } catch (e) {
      emit(CreateLoanError(message: e.toString()));
    }
  }

}