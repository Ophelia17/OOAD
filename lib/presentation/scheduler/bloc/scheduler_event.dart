part of 'scheduler_bloc.dart';

abstract class SchedulerEvent extends Equatable {
  const SchedulerEvent();

  @override
  List<Object> get props => [];
}

class EditScheduler extends SchedulerEvent {
  const EditScheduler();

  @override
  List<Object> get props => [];
}

class SaveScheduler extends SchedulerEvent {
  SaveScheduler({required this.userSchedule});
  List<Map<String, String>> userSchedule;

  @override
  List<Object> get props => [userSchedule];
}