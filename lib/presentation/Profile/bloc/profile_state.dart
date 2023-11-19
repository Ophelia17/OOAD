part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLogOutTryingState extends ProfileState {
  const ProfileLogOutTryingState();

  @override
  List<Object?> get props => [];
}

class ProfileLogOutSuccessState extends ProfileState {
  const ProfileLogOutSuccessState();

  @override
  List<Object?> get props => [];
}

class ProfileLogOutErrorState extends ProfileState {
  const ProfileLogOutErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();

  @override
  List<Object?> get props => [];
}

class ProfileSuccessState extends ProfileState {
  const ProfileSuccessState({required this.userInfo});
  final Map<String, dynamic> userInfo;

  @override
  List<Object?> get props => [];
}

class ProfileErrorState extends ProfileState {
  const ProfileErrorState();

  @override
  List<Object?> get props => [];
}

class EditScheduleState extends ProfileState {
  const EditScheduleState();

  @override
  List<Object?> get props => [];
}

class GetFriendsLoadingState extends ProfileState {
  const GetFriendsLoadingState();

  @override
  List<Object?> get props => [];
}

class GetFriendsSuccessState extends ProfileState {
  const GetFriendsSuccessState(
      {required this.userFriends, required this.userFriendUids});
  final List<dynamic> userFriends;
  final List<dynamic> userFriendUids;

  @override
  List<Object?> get props => [];
}

class GetFriendsErrorState extends ProfileState {
  const GetFriendsErrorState();

  @override
  List<Object?> get props => [];
}

class GetUserScheduleLoadingState extends ProfileState {
  const GetUserScheduleLoadingState();

  @override
  List<Object?> get props => [];
}

class GetUserScheduleSuccessState extends ProfileState {
  const GetUserScheduleSuccessState({required this.userSchedule});
  final List<dynamic> userSchedule;

  @override
  List<Object?> get props => [];
}

class GetUserScheduleNotPresentState extends ProfileState {
  const GetUserScheduleNotPresentState();

  @override
  List<Object?> get props => [];
}
