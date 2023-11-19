part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginTryingState extends LoginState {
  const LoginTryingState();

  @override
  List<Object?> get props => [];  
}

class LoginErrorState extends LoginState {
  const LoginErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState(); //TODO: add some credentials part in state

  @override
  List<Object?> get props => [];
}