import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'screen_event.dart';
part 'screen_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToScreen>(_onNavigateToScreen);
  }

  void _onNavigateToScreen(NavigateToScreen event, Emitter<NavigationState> emit) {
    emit(NavigationChanged(event.screenIndex));
  }
}