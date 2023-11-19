import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enono/services/auth.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/services/firestore_db.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(LocalStorageService localStorageService)
      : super(const ProfileState()) {
    on<ProfileTryLogOutEvent>(
        (ProfileTryLogOutEvent event, Emitter<ProfileState> emit) async {
      emit(const ProfileLogOutTryingState());
      final dynamic status =
          await logOut(localStorageService.isLoggedInWithGoogle);
      localStorageService.isLoggedIn = false;
      localStorageService.isLoggedInWithGoogle = false;
      localStorageService.uid = 'null';
      if (status == true) {
        emit(const ProfileLogOutSuccessState());
      } else {
        emit(ProfileLogOutErrorState(code: status));
      }
    });

    on<GetUserInfo>((GetUserInfo event, Emitter<ProfileState> emit) async {
      emit(const ProfileLoadingState());
      Map<String, dynamic> userInfo =
          await getUserEmailAndName(localStorageService.uid);
      emit(ProfileSuccessState(userInfo: userInfo));
      if (userInfo['name'] == null) {
        emit(const ProfileErrorState());
      }
      List<dynamic> userSchedule =
          await getUserSchedule(localStorageService.uid);
      emit(GetUserScheduleSuccessState(userSchedule: userSchedule));
      if (userSchedule.isEmpty) {
        emit(const GetUserScheduleNotPresentState());
      }
      List<dynamic> userFriendUids =
          await getUserFriends(localStorageService.uid);
      List<dynamic> userFriendNames = await getNameListFromUids(userFriendUids);
      emit(GetFriendsSuccessState(
          userFriends: userFriendNames, userFriendUids: userFriendUids));
      if (userFriendUids.isEmpty) {
        emit(const GetFriendsErrorState());
      }
    });

    on<GetUserSchedule>(
        ((GetUserSchedule event, Emitter<ProfileState> emit) async {
      emit(const GetUserScheduleLoadingState());
      List<dynamic> userSchedule =
          await getUserSchedule(localStorageService.uid);
      emit(GetUserScheduleSuccessState(userSchedule: userSchedule));
      if (userSchedule.isEmpty) {
        emit(const GetUserScheduleNotPresentState());
      }
    }));

    // on<GetFriends>((GetFriends event, Emitter<ProfileState> emit) async {
    //   emit(const GetFriendsLoadingState());
    //   List<dynamic> userFriends = await getUserFriends(localStorageService.uid);
    //   emit(GetFriendsSuccessState(userFriends: userFriends));
    //   if (userFriends.isEmpty) {
    //     emit(const GetFriendsErrorState());
    //   }
    // });
  }
}
