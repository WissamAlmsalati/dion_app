import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../authintication_feature/services/auth_service.dart';
import '../../models/loan.dart';
import '../../domain/repostry/loans_repostry.dart';

part 'get_list_of_loans_event.dart';
part 'get_list_of_loans_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final LoanRepository loanRepository;

  LoanBloc({required this.loanRepository}) : super(LoanInitial()) {
    on<LoadLoans>(_onLoadLoans);
    on<LoadLoanDetails>(_onLoadLoanDetails); // Added for loading loan details.
  }

Future<void> _onLoadLoans(
    LoadLoans event, Emitter<LoanState> emit) async {
  emit(LoanLoading());
  try {
    final result = await loanRepository.fetchLoans(
      page: event.page,
      pageSize: 50,
      loanType: event.loanType,
    );
    final List<Loan> loans = result['loans'] as List<Loan>;
    emit(LoanLoaded(loans));
  } catch (e) {
    emit(LoanError("Failed to load loans: $e"));
  }
}


  Future<void> _onLoadLoanDetails(
      LoadLoanDetails event, Emitter<LoanState> emit) async {
    emit(LoanLoading());
    try {
      final loan = await loanRepository.getLoanDetails(event.loanId);
      // Assuming LoanLoaded can accept a list with a single loan.
      emit(LoanLoaded([loan]));
    } catch (e) {
      emit(LoanError("Failed to load loan details: $e"));
    }
  }
}
