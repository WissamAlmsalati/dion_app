part of 'screen_bloc.dart';

abstract class NavigationEvent {}

class NavigateToScreen extends NavigationEvent {
  final int screenIndex;
  NavigateToScreen(this.screenIndex);
}