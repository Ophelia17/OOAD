import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enono/services/auth.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/services/firestore_db.dart';

part 'hamburger_event.dart';
part 'hamburger_state.dart';

class HamburgerBloc extends Bloc<HamburgerEvent, HamburgerState> {
  HamburgerBloc(LocalStorageService localStorageService)
      : super(const HamburgerState()) {
    on<HamburgerTryLogOutEvent>(
        (HamburgerTryLogOutEvent event, Emitter<HamburgerState> emit) async {
      emit(const HamburgerLogOutTryingState());
      final dynamic status =
          await logOut(localStorageService.isLoggedInWithGoogle);
      localStorageService.isLoggedIn = false;
      localStorageService.isLoggedInWithGoogle = false;
      localStorageService.uid = 'null';
      if (status == true) {
        emit(const HamburgerLogOutSuccessState());
      } else {
        emit(HamburgerLogOutErrorState(code: status));
      }
    });

    on<HamburgerGetUserInfo>(
        (HamburgerGetUserInfo event, Emitter<HamburgerState> emit) async {
      emit(const HamburgerGetUserInfoLoadingState());
      Map<String, dynamic> userInfo =
          await getUserEmailAndName(localStorageService.uid);
      emit(HamburgerGetUserInfoSuccessState(userInfo: userInfo));
      if (userInfo['name'] == null) {
        emit(const HamburgerGetUserInfoErrorState());
      }
    });
  }
}
