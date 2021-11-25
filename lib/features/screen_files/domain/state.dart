import 'package:test_task_xdevteam/features/screen_files/domain/model/files_info.dart';

abstract class FilesScreenState {}

class OnFilesViewState extends FilesScreenState {
  final FilesScreenInfo filesInfo;

  OnFilesViewState({
    required this.filesInfo,
  });
}

class OnLoading extends FilesScreenState {}

class OnError extends FilesScreenState {
  final String? errorMessage;

  OnError({this.errorMessage});
}
