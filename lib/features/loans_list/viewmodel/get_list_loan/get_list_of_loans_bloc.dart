import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../authintication_feature/services/auth_service.dart';
import '../../models/loan.dart';
import '../../repostry/loans_repostry.dart';

part 'get_list_of_loans_event.dart';
part 'get_list_of_loans_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final LoanRepository loanRepository;

  LoanBloc({required this.loanRepository}) : super(LoanInitial()) {
    on<LoadLoans>(_onLoadLoans);
    on<LoadLoanDetails>(_onLoadLoanDetails); // Add this line
  }

  Future<void> _onLoadLoans(LoadLoans event, Emitter<LoanState> emit) async {
    emit(LoanLoading());
    try {
      final loans = await loanRepository.fetchLoans(page: event.page, pageSize: 50);
      emit(LoanLoaded(loans));
    } catch (e) {
      emit(LoanError("Failed to load loans: $e"));
    }
  }

  Future<void> _onLoadLoanDetails(LoadLoanDetails event, Emitter<LoanState> emit) async {
    emit(LoanLoading());
    try {
      final loan = await loanRepository.getLoanDetails(event.loanId);
      emit(LoanLoaded([loan])); // Assuming LoanLoaded can handle a single loan
    } catch (e) {
      emit(LoanError("Failed to load loan details: $e"));
    }
  }
}