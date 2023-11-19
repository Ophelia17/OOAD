part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class TryLoginEvent extends LoginEvent {
  const TryLoginEvent({required this.email, required this.password});
  final String email, password;

  @override
  List<Object?> get props => [email, password];
}

class LoginGoogleEvent extends LoginEvent {
  const LoginGoogleEvent();

  @override
  List<Object?> get props => [];
}