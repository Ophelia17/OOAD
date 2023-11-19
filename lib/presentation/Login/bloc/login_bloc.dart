import 'package:enono/services/firestore_db.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/services/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LocalStorageService localStorageService)
      : super(const LoginState()) {
    on<TryLoginEvent>((TryLoginEvent event, Emitter<LoginState> emit) async {
      emit(const LoginTryingState());
      //firebase auth work
      final dynamic status =
          await loginEmailPassword(event.email, event.password);
      if (status == 'registration_pending') {
        emit(const LoginErrorState(code: 'Please register first'));
      }
      if (status != false) {
        localStorageService.isLoggedIn = true;
        print(status);
        localStorageService.uid = status;
        print('reached at end of login event');
        getAllUsers();
        emit(const LoginSuccessState());
      } else {
        emit(LoginErrorState(code: status));
      }
    });

    on<LoginGoogleEvent>(
        (LoginGoogleEvent event, Emitter<LoginState> emit) async {
      final dynamic status = await signInWithGoogle();
      if (status == 'registration_pending') {
        emit(const LoginErrorState(code: 'Please register first'));
      }
      if (status == false) {
        emit(const LoginErrorState(code: "Sign in with Google failed"));
      } else {
        localStorageService.isLoggedIn = true;
        localStorageService.isLoggedInWithGoogle = true;
        localStorageService.uid = status;
        emit(const LoginSuccessState());
        print('reached at end of login event');
      }
    });
  }
}
