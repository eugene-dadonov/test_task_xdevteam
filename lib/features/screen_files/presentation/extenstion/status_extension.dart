import 'package:test_task_xdevteam/core/strings.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/status.dart';

extension StatusX on Status {
  String toTitle() {
    switch (this) {
      case Status.waiting:
        return AppLocalization.titleStatusWaiting;
      case Status.uploading:
        return AppLocalization.titleStatusUploading;
      case Status.uploaded:
        return AppLocalization.titleStatusUploaded;
    }
  }
}
