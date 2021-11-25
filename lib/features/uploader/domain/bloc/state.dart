import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

abstract class UploaderState {}

class UploaderInitialization extends UploaderState {}

class UploadedFiles extends UploaderState {
  final List<FileInfo> files;

  UploadedFiles({
    required this.files,
  });
}

class UploaderError extends UploaderState {}
