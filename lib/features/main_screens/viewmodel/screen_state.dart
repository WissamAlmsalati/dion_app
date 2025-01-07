part of 'screen_bloc.dart';

abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationChanged extends NavigationState {
  final int screenIndex;
  NavigationChanged(this.screenIndex);
}