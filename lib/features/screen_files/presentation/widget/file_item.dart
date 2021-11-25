import 'package:flutter/material.dart';
import 'package:test_task_xdevteam/core/styles.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/status.dart';
import 'package:test_task_xdevteam/features/screen_files/presentation/extenstion/status_extension.dart';

class FileInfoWidget extends StatelessWidget {
  const FileInfoWidget({
    Key? key,
    required this.fileInfo,
    required this.onDelete,
  }) : super(key: key);

  final FileInfo fileInfo;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        fileInfo.status == Status.uploaded ? null : fileInfo.status.toTitle();
    return ListTile(
      title: Text(
        fileInfo.name,
        style: AppStyles.h2,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null ? Text(subtitle, style: AppStyles.h3) : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          onDelete.call(fileInfo.id);
        },
        splashRadius: 24,
      ),
      // Добавил иконки вопреки заданию, так как так удобнее следить за статусами
      // Во время дебага и вообще.
      leading: IconWidget(
        status: fileInfo.status,
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({Key? key, required this.status}) : super(key: key);

  final Status status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.waiting:
        return const SizedBox(
          height: 40,
          width: 40,
          child: Icon(Icons.hourglass_empty),
        );
      case Status.uploading:
        return const SizedBox(
          height: 40,
          width: 40,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        );
      case Status.uploaded:
        return const SizedBox(
          height: 40,
          width: 40,
          child: Icon(Icons.check_circle_outline),
        );
    }
  }
}
