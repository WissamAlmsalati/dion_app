import 'package:dion_app/features/loand_detail_feature/domain/repository/loan_detail_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_detail_event.dart';
import 'loan_detail_state.dart';

class LoanDetailBloc extends Bloc<LoanDetailEvent, LoanDetailState> {
  final LoanDetailRepository repository;

  LoanDetailBloc({required this.repository}) : super(LoanDetailInitial()) {
    on<LoadLoanDetail>(_onLoadLoanDetail);
  }

  Future<void> _onLoadLoanDetail(
    LoadLoanDetail event,
    Emitter<LoanDetailState> emit,
  ) async {
    emit(LoanDetailLoading());
    try {
      final loan = await repository.fetchLoanDetail(
        loanId: event.loanId,
      );
      emit(LoanDetailLoaded(loan: loan));
    } catch (error) {
      emit(LoanDetailError(message: error.toString()));
    }
  }
}
