import 'package:bloc/bloc.dart';
import 'package:dion_app/features/loans_list/domain/repostry/settling_reposotory.dart';
import 'package:equatable/equatable.dart';

part 'settle_loan_event.dart';
part 'settle_loan_state.dart';

class SettleLoanBloc extends Bloc<SettleLoanEvent, SettleLoanState> {
  final SettlingRepository settlingRepository;

  SettleLoanBloc({required this.settlingRepository}) : super(SettleLoanInitial()) {
    on<SettleLoan>(_onSettleLoan);
    on<AcceptLoan>(_onAcceptLoan);
    on<RejectLoan>(_onRejectLoan);
  }

Future<void> _onSettleLoan(SettleLoan event, Emitter<SettleLoanState> emit) async {
  emit(SettleLoanLoading());
  try {
    final message = await settlingRepository.settleLoan(event.loanId, event.amount);
    emit(SettleLoanSuccess(message: message));
  } catch (e) {
    emit(SettleLoanFailure(error: e.toString()));
  }
}


  Future<void> _onAcceptLoan(AcceptLoan event, Emitter<SettleLoanState> emit) async {
    emit(AcceptLoanLoading());
    try {
      await settlingRepository.updateLoanStatus(event.loanId, event.status);
      emit(AcceptLoanSuccess());
    } catch (e) {
      emit(SettleLoanFailure(error: e.toString()));
    }
  }

  Future<void> _onRejectLoan(RejectLoan event, Emitter<SettleLoanState> emit) async {
    emit(RejectLoanLoading());
    try {
      await settlingRepository.updateLoanStatus(event.loanId, event.status);
      emit(RejectLoanSuccess());
    } catch (e) {
      emit(SettleLoanFailure(error: e.toString()));
    }
  }


}