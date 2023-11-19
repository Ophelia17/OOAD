part of 'landing_bloc.dart';

abstract class LandingEvent extends Equatable {
  const LandingEvent();

  @override
  List<Object?> get props => [];
}

class TryLogOutEvent extends LandingEvent {
  const TryLogOutEvent();

  @override
  List<Object?> get props => [];
}

class GetMemberLocations extends LandingEvent {
  const GetMemberLocations();
  // final String uid;

  @override
  List<Object?> get props => [];
}

class RefreshLocations extends LandingEvent{
  const RefreshLocations();

  @override
  List<Object?> get props => [];
}

class DisposeBlocEvent extends LandingEvent {
  const DisposeBlocEvent();
  // final String uid;

  @override
  List<Object?> get props => [];
}

// class ShowRequestsEvent extends LandingEvent {
//   const ShowRequestsEvent();

//   @override
//   List<Object?> get props => [];
// }

class DeclineRequestEvent extends LandingEvent {
  const DeclineRequestEvent({required this.senderEmail});
  final String senderEmail;

  @override
  List<Object?> get props => [senderEmail];  
}

class AcceptRequestEvent extends LandingEvent {
  const AcceptRequestEvent({required this.senderEmail});
  final String senderEmail;

  @override
  List<Object?> get props => [senderEmail];  
}

class InitialEvent extends LandingEvent {
  const InitialEvent();

  @override
  List<Object?> get props => [];
}

class LandingGetFriends extends LandingEvent {
  const LandingGetFriends();

  @override
  List<Object?> get props => [];
}

class LandingGetFriendOptions extends LandingEvent {
  const LandingGetFriendOptions();

  @override
  List<Object?> get props => [];
}

class LandingSelectFriend extends LandingEvent {
  const LandingSelectFriend(
      {required this.friendName,
      required this.friendUids,
      required this.friendNames});
  final dynamic friendNames;
  final dynamic friendUids;
  final dynamic friendName;

  @override
  List<Object?> get props => [friendName];
}

class LoadLandingScreen extends LandingEvent {
  const LoadLandingScreen();

  @override
  List<Object?> get props => [];
}

class DestinationTypeSelect extends LandingEvent {
  const DestinationTypeSelect({required this.destinationType});
  final dynamic destinationType;

  @override
  List<Object?> get props => [destinationType];
}