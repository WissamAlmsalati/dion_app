import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../loans_list/domain/repostry/accept_loan_repository.dart';

part 'update_loan_status_event.dart';
part 'update_loan_status_state.dart';

class LoanStatusBloc extends Bloc<UpdateLoanStatusEvent, LoanStatusState> {
  final AcceptLoanRepository acceptLoanRepository;

  LoanStatusBloc({required this.acceptLoanRepository}) : super(LoanStatusInitial()) {
    on<UpdateLoanStatus>(_onUpdateLoanStatus);
  }

  Future<void> _onUpdateLoanStatus(UpdateLoanStatus event, Emitter<LoanStatusState> emit) async {
    emit(LoanStatusLoading());
    try {
      final message = await acceptLoanRepository.updateLoanStatus(event.loanId, event.loanStatus);
      emit(LoanStatusSuccess(message: message));
    } catch (e) {
      emit(LoanStatusFailure(error: e.toString()));
    }
  }
}