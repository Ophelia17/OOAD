part of 'landing_bloc.dart';

class LandingState extends Equatable {
  const LandingState();

  @override
  List<Object?> get props => [];
}

class LogOutTryingState extends LandingState {
  const LogOutTryingState();

  @override
  List<Object?> get props => [];
}

class LogOutSuccessState extends LandingState {
  const LogOutSuccessState();

  @override
  List<Object?> get props => [];
}

class LogOutErrorState extends LandingState {
  const LogOutErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class LandingLoadingState extends LandingState {
  const LandingLoadingState();

  @override
  List<Object?> get props => [];
}

class LoadMapState extends LandingState {
  const LoadMapState();
  @override
  List<Object?> get props => [];
}

class ShowRequestsState extends LandingState {
  const ShowRequestsState({required this.emailIds});
  final List<String> emailIds;

  @override
  List<Object?> get props => [emailIds];
}

class LandingGetFriendsLoadingState extends LandingState {
  const LandingGetFriendsLoadingState();

  @override
  List<Object?> get props => [];
}

class LandingGetFriendsSuccessState extends LandingState {
  const LandingGetFriendsSuccessState(
      {required this.userFriends, required this.userFriendUids});
  final List<dynamic> userFriends;
  final List<dynamic> userFriendUids;

  @override
  List<Object?> get props => [];
}

class LandingGetFriendsErrorState extends LandingState {
  const LandingGetFriendsErrorState();

  @override
  List<Object?> get props => [];
}

class LandingGetFriendOptionsLoading extends LandingState {
  const LandingGetFriendOptionsLoading();

  @override
  List<Object?> get props => [];
}

class LandingGetFriendOptionsSuccess extends LandingState {
  const LandingGetFriendOptionsSuccess(
      {required this.friendNames, required this.friendUids});
  final List<dynamic> friendNames;
  final List<dynamic> friendUids;

  @override
  List<Object?> get props => [];
}

class LandingGetFriendOptionsError extends LandingState {
  const LandingGetFriendOptionsError();

  @override
  List<Object?> get props => [];
}

class LandingSelectFriendLoading extends LandingState {
  const LandingSelectFriendLoading();

  @override
  List<Object?> get props => [];
}

class LandingSelectFriendSuccess extends LandingState {
  const LandingSelectFriendSuccess(
      {required this.currentFriend,
      required this.friendSelected,
      required this.currentFriendUid});
  final dynamic currentFriendUid;
  final dynamic currentFriend;
  final dynamic friendSelected;

  @override
  List<Object?> get props => [];
}

class LandingSelectFriendError extends LandingState {
  const LandingSelectFriendError();

  @override
  List<Object?> get props => [];
}

class DestinationTypeSelectSuccess extends LandingState {
  const DestinationTypeSelectSuccess({required this.destinationType});
  final dynamic destinationType;

  @override
  List<Object?> get props => [];
}