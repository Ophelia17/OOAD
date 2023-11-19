part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileTryLogOutEvent extends ProfileEvent {
  const ProfileTryLogOutEvent();

  @override
  List<Object?> get props => [];
}

class GetFriends extends ProfileEvent {
  const GetFriends();

  @override
  List<Object?> get props => [];
}

class EditSchedule extends ProfileEvent {
  const EditSchedule();

  @override
  List<Object?> get props => [];
}

class UpdateScheduleToDatabase extends ProfileEvent {
  const UpdateScheduleToDatabase();

  @override
  List<Object?> get props => [];
}

class AddUserProfilePhoto extends ProfileEvent {
  const AddUserProfilePhoto();

  @override
  List<Object?> get props => [];
}

class GetUserInfo extends ProfileEvent {
  const GetUserInfo();

  @override
  List<Object?> get props => [];
}

class GetUserSchedule extends ProfileEvent {
  const GetUserSchedule();

  @override
  List<Object?> get props => [];
}
