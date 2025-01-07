import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/loaning_data.dart';
import '../repository/loaning_repository.dart';

part 'loaning_event.dart';
part 'loaning_state.dart';

class LoaningBloc extends Bloc<LoaningEvent, LoaningState> {
  final LoaningRepository repository = LoaningRepository();

  LoaningBloc() : super(LoaningInitial()) {
    on<FetchLoaningData>(_onFetchLoaningData);
  }

  void _onFetchLoaningData(FetchLoaningData event, Emitter<LoaningState> emit) async {
    emit(LoaningLoading());
    try {
      final data = await repository.fetchLoaningData();
      emit(LoaningLoaded(data));
    } catch (e) {
      print(e);
      emit(LoaningError(e.toString()));
    }
  }
}