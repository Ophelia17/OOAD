part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class TryRegistrationEvent extends RegistrationEvent {
  const TryRegistrationEvent({required this.username, required this.email, required this.password});
  final String username, email, password;

  @override
  List<Object?> get props => [username, email, password];
}