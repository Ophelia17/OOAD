part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationTryingState extends RegistrationState {
  const RegistrationTryingState();

  @override
  List<Object?> get props => [];  
}

class RegistrationErrorState extends RegistrationState {
  const RegistrationErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class RegistrationSuccessState extends RegistrationState {
  const RegistrationSuccessState(); //TODO: add some credentials part in state

  @override
  List<Object?> get props => [];
}