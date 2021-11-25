import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

abstract class UploaderService {
  Stream<FileInfo> get filesInfo;

  void init();

  void enqueue(List<FileInfo> files);

  void dequeue(FileInfo file);

  void clean();
}
