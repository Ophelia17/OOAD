import 'package:enono/services/firestore_db.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'package:enono/data/local/local_database_service.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(LocalStorageService localStorageService)
      : super(const RegistrationState()) {
    on<TryRegistrationEvent>(
        (TryRegistrationEvent event, Emitter<RegistrationState> emit) async {
      emit(const RegistrationTryingState());
      LocationPermission permission = await Geolocator.requestPermission();
      while (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        const AlertDialog(
          title: Text('Error'),
          content: Text('Location Permission Denied, please provide them'),
        );
        permission = await Geolocator.requestPermission();
      }
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password)
            .then((value) async {
          String uid = value.user!.uid;
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          final dynamic status = await registerNewUser(uid, event.username,
              event.email, [position.latitude, position.longitude]);
          if (status != false) {
            //localStorageService.isRegistered = true;
            // localStorageService.isLoggedIn = true;
            print(status);
            // localStorageService.uid = uid;
            emit(const RegistrationSuccessState());
          } else {
            emit(RegistrationErrorState(code: status));
          }
        });
      } catch (e) {
        AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        );
      }
    });
  }
}
