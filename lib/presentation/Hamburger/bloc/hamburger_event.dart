part of 'hamburger_bloc.dart';

abstract class HamburgerEvent extends Equatable {
  const HamburgerEvent();

  @override
  List<Object?> get props => [];
}

class HamburgerGetUserInfo extends HamburgerEvent {
  const HamburgerGetUserInfo();

  @override
  List<Object?> get props => [];
}

class HamburgerTryLogOutEvent extends HamburgerEvent {
  const HamburgerTryLogOutEvent();

  @override
  List<Object?> get props => [];
}
