import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repostry/accept_loan_repository.dart';

part 'update_loan_status_event.dart';
part 'update_loan_status_state.dart';

class LoanStatusBloc extends Bloc<LoanStatusEvent, LoanStatusState> {
  LoanStatusBloc() : super(LoanStatusInitial()) {
    on<UpdateLoanStatus>(_onUpdateLoanStatus);
  }

  Future<void> _onUpdateLoanStatus(UpdateLoanStatus event, Emitter<LoanStatusState> emit) async {
    emit(LoanStatusLoading());
    try {
      await AcceptLoanRepository().updateLoanStatus(event.loanId, event.loanStatus);
      emit(LoanStatusSuccess());
    } catch (e) {
      emit(LoanStatusFailure(error: e.toString()));
    }
  }
}
