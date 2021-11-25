import 'package:test_task_xdevteam/features/screen_home/domain/model/files_info.dart';

abstract class HomeScreenState {}

class OnViewLoading extends HomeScreenState {}

class OnViewState extends HomeScreenState {
  final HomeScreenInfo filesInfo;

  OnViewState({
    required this.filesInfo,
  });
}

class OnError extends HomeScreenState {
  final String? message;

  OnError({this.message});
}

class OnNavigateToFiles extends HomeScreenState {}

class OnSaveFiles extends HomeScreenState {}
