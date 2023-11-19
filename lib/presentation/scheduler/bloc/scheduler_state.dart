part of 'scheduler_bloc.dart';

class SchedulerState extends Equatable {
  const SchedulerState();

  @override
  List<Object?> get props => [];
}

// class ScheduleInitialState extends SchedulerState {
//   Schedu
// }

class ScheduleViewState extends SchedulerState {
  const ScheduleViewState();

  @override
  List<Object?> get props => [];
}

class ScheduleEditState extends SchedulerState {
  const ScheduleEditState();

  @override
  List<Object?> get props => [];
}

class ScheduleErrorState extends SchedulerState {
  const ScheduleErrorState({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}