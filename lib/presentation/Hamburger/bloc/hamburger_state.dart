part of 'hamburger_bloc.dart';

class HamburgerState extends Equatable {
  const HamburgerState();

  @override
  List<Object?> get props => [];
}

class HamburgerGetUserInfoLoadingState extends HamburgerState {
  const HamburgerGetUserInfoLoadingState();

  @override
  List<Object?> get props => [];
}

class HamburgerGetUserInfoSuccessState extends HamburgerState {
  const HamburgerGetUserInfoSuccessState({required this.userInfo});
  final Map<String, dynamic> userInfo;

  @override
  List<Object?> get props => [];
}

class HamburgerGetUserInfoErrorState extends HamburgerState {
  const HamburgerGetUserInfoErrorState();

  @override
  List<Object?> get props => [];
}

class HamburgerLogOutTryingState extends HamburgerState {
  const HamburgerLogOutTryingState();

  @override
  List<Object?> get props => [];
}

class HamburgerLogOutSuccessState extends HamburgerState {
  const HamburgerLogOutSuccessState();

  @override
  List<Object?> get props => [];
}

class HamburgerLogOutErrorState extends HamburgerState {
  const HamburgerLogOutErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}
