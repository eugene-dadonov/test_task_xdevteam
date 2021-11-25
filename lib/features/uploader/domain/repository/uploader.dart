import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

abstract class RepositoryUploader {
  Stream<List<FileInfo>> get fileInfos;

  void enqueue(List<FileInfo> files);

  void dequeue(String id);

  void clear();
}
