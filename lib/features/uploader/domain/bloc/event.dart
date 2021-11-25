import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

abstract class UploaderEvent {}

class Enqueue extends UploaderEvent {
  final List<FileInfo> files;

  Enqueue({
    required this.files,
  });
}

class Dequeue extends UploaderEvent {
  final String fileUid;

  Dequeue({
    required this.fileUid,
  });
}

class ClearQueue extends UploaderEvent {}