import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enono/presentation/Landing/landing_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;

import 'package:enono/services/auth.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/services/firestore_db.dart';

part 'landing_event.dart';
part 'landing_state.dart';

bool requestsShowed = false;

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc(LocalStorageService localStorageService)
      : super(const LandingState()) {
    on<InitialEvent>((InitialEvent event, Emitter<LandingState> emit) async {
      emit(const LandingLoadingState());
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      updatePosition(
          [position.latitude, position.longitude], localStorageService.uid);
      await getAllUsers();
      Map<String, Map<String, List<double>>> allGroupMemberLocations = {
        "friends": {}
      };
      Map<String, GeoPoint> friendsAndLocations =
          await getFriendsAndLocations(localStorageService.uid);
      for (var friend in friendsAndLocations.keys) {
        allGroupMemberLocations["friends"]!.addAll({
          friend: [
            friendsAndLocations[friend]!.latitude,
            friendsAndLocations[friend]!.longitude
          ]
        });
      }
      emit(LoadMapState());
      // print('just before getting requests');
      // final List<String> requests = await showExistingFriendRequests(localStorageService.uid);
      // print('requests are $requests');
      // emit(ShowRequestsState(emailIds: requests));
    });
    on<GetMemberLocations>(
        (GetMemberLocations event, Emitter<LandingState> emit) async {
      print("reached eh");
      emit(const LandingLoadingState());
      // List<String> groups = await getGroups(localStorageService.uid);
      // Map<String, Map<String, List<double>>> allGroupMemberLocations = {};
      // for (String group in groups) {
      //   Map<String, GeoPoint> currGroupMembers = await allUserLocations(group);
      //   print('all user locations are fetched');
      //   allGroupMemberLocations[group] ??= {};
      //   currGroupMembers.entries.forEach((element) {
      //     allGroupMemberLocations[group]?.addAll({
      //       element.key: [element.value.latitude, element.value.longitude]
      //     });
      //     // print(
      //     //     'new entry added ${element.value.latitude} ${element.value.longitude}');
      //   });
      //allGroupMemberLocations.addAll({group: currGroupMembers});
      // }
      Map<String, Map<String, List<double>>> allGroupMemberLocations = {
        "friends": {}
      };
      Map<String, GeoPoint> friendsAndLocations =
          await getFriendsAndLocations(localStorageService.uid);
      for (var friend in friendsAndLocations.keys) {
        allGroupMemberLocations["friends"]!.addAll({
          friend: [
            friendsAndLocations[friend]!.latitude,
            friendsAndLocations[friend]!.longitude
          ]
        });
      }
      emit(LoadMapState());
      print('locations withing bloc file $allGroupMemberLocations');
    });
    on<TryLogOutEvent>(
        (TryLogOutEvent event, Emitter<LandingState> emit) async {
      emit(const LogOutTryingState());
      final dynamic status =
          await logOut(localStorageService.isLoggedInWithGoogle);
      localStorageService.isLoggedIn = false;
      localStorageService.isLoggedInWithGoogle = false;
      localStorageService.uid = 'null';
      if (status == true) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        updatePosition(
            [position.latitude, position.longitude], localStorageService.uid);
        emit(const LogOutSuccessState());
      } else {
        emit(LogOutErrorState(code: status));
      }
    });
    on<RefreshLocations>(
        (RefreshLocations event, Emitter<LandingState> emit) async {
      emit(const LandingLoadingState());
      List<String> groups = await getGroups(localStorageService.uid);
      Map<String, Map<String, List<double>>> allGroupMemberLocations = {};
      for (String group in groups) {
        Map<String, GeoPoint> currGroupMembers = await allUserLocations(group);
        print('all user locations are fetched');
        allGroupMemberLocations[group] ??= {};
        currGroupMembers.entries.forEach((element) {
          allGroupMemberLocations[group]?.addAll({
            element.key: [element.value.latitude, element.value.longitude]
          });
        });
      }
      emit(LoadMapState());
    });
    // on<ShowRequestsEvent>(
    //     (ShowRequestsEvent event, Emitter<LandingState> emit) {});
    on<DeclineRequestEvent>(
        (DeclineRequestEvent event, Emitter<LandingState> emit) {
      declineFriendRequest(localStorageService.uid, event.senderEmail);
    });
    on<AcceptRequestEvent>(
        (AcceptRequestEvent event, Emitter<LandingState> emit) {
      acceptFriendRequest(localStorageService.uid, event.senderEmail);
    });
    on<LandingGetFriends>(
        (LandingGetFriends event, Emitter<LandingState> emit) async {
      emit(const LandingGetFriendsLoadingState());
      List<dynamic> userFriends = await getUserFriends(localStorageService.uid);
      List<dynamic> userFriendNames = await getNameListFromUids(userFriends);
      emit(LandingGetFriendsSuccessState(
          userFriends: userFriendNames, userFriendUids: userFriends));
      if (userFriends.isEmpty) {
        emit(const LandingGetFriendsErrorState());
      }
    });

    on<LandingGetFriendOptions>(
      (LandingGetFriendOptions event, Emitter<LandingState> emit) async {
        emit(const LandingGetFriendOptionsLoading());
        // print("Hellllllllllllllllllllllllllllllloooooooooooooooo");
        List<dynamic> userFriendUidsOptions =
            await getUserFriendOptions(localStorageService.uid);
        List<dynamic> userFriendNamesOptions =
            await getNameListFromUids(userFriendUidsOptions);
        emit(LandingGetFriendOptionsSuccess(
            friendNames: userFriendNamesOptions,
            friendUids: userFriendUidsOptions));
        if (userFriendUidsOptions.isEmpty) {
          emit(const LandingGetFriendOptionsError());
        }
      },
    );

    on<LandingSelectFriend>(
      (LandingSelectFriend event, Emitter<LandingState> emit) async {
        dynamic friendUid;
        for (int i = 0; i < event.friendNames.length; i++) {
          if (event.friendNames[i] == event.friendName) {
            friendUid = event.friendUids[event.friendNames.length - 1 - i];
          }
        }
        await mapController.addMarker(osm.GeoPoint(latitude:nameToLocation[event.friendName]![0], longitude: nameToLocation[event.friendName]![1]));
        emit(LandingSelectFriendSuccess(
            currentFriend: event.friendName,
            friendSelected: true,
            currentFriendUid: friendUid));
        emit(LoadMapState());
        if (event.friendName == null || event.friendName == "") {
          emit(const LandingSelectFriendError());
        }
      },
    );

    on<LoadLandingScreen>(
      (LoadLandingScreen event, Emitter<LandingState> emit) async {
        emit(const LandingGetFriendOptionsLoading());
        List<dynamic> userFriendUidsOptions =
            await getUserFriendOptions(localStorageService.uid);
        List<dynamic> userFriendNamesOptions =
            await getNameListFromUids(userFriendUidsOptions);
        emit(LandingGetFriendOptionsSuccess(
            friendNames: userFriendNamesOptions,
            friendUids: userFriendUidsOptions));
        if (userFriendUidsOptions.isEmpty) {
          emit(const LandingGetFriendOptionsError());
        }

        emit(const LandingGetFriendsLoadingState());
        List<dynamic> userFriends =
            await getUserFriends(localStorageService.uid);
        List<dynamic> userFriendNames = await getNameListFromUids(userFriends);
        emit(LandingGetFriendsSuccessState(
            userFriends: userFriendNames, userFriendUids: userFriends));
        if (userFriends.isEmpty) {
          emit(const LandingGetFriendsErrorState());
        }
      },
    );

    on<DestinationTypeSelect>(
      (DestinationTypeSelect event, Emitter<LandingState> emit) {
        emit(DestinationTypeSelectSuccess(
            destinationType: event.destinationType));
      },
    );
  }
}
