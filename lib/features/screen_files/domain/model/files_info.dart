import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

class FilesScreenInfo {
  final List<FileInfo> filesInfo;

  FilesScreenInfo({
    required this.filesInfo,
  });

  FilesScreenInfo.empty() : filesInfo = [];
}
