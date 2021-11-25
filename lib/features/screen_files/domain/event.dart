import 'dart:io';

abstract class FilesScreenEvent {}

class FilesOpened extends FilesScreenEvent {}

class EnqueueFiles extends FilesScreenEvent {
  final List<String?> paths;

  EnqueueFiles({required this.paths});
}

class DequeueFile extends FilesScreenEvent {
  final String id;

  DequeueFile({
    required this.id,
  });
}
