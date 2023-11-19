import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/services/firestore_db.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:html';

part 'scheduler_event.dart';
part 'scheduler_state.dart';

class SchedulerBloc extends Bloc<SchedulerEvent, SchedulerState> {
  SchedulerBloc(LocalStorageService localStorageService)
      : super(const SchedulerState()) {
    on<EditScheduler>(
        (EditScheduler event, Emitter<SchedulerState> emit) async {
      emit(const ScheduleEditState());
    });
    on<SaveScheduler>(
        (SaveScheduler event, Emitter<SchedulerState> emit) async {
      final dynamic status =
          await updateUserSchedule(localStorageService.uid, event.userSchedule);
      if (status != false) {
        //firebase work? idk it's a database thing.......
        emit(const ScheduleViewState());
      } else {
        emit(ScheduleErrorState(code: status));
      }
    });
  }
}