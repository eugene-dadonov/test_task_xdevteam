import 'dart:async';
import 'package:test_task_xdevteam/features/uploader/data/service/uploader_service.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/repository/uploader.dart';

class FileUploaderRepository extends RepositoryUploader {
  FileUploaderRepository({
    required this.uploaderService,
  }) {
    controller = StreamController<List<FileInfo>>();
    _notify();

    uploaderService.filesInfo.listen((fileInfo) {
      // Тут нужна проверка на случай, если мы удалили незагруженный файл,
      // так как я не сделал хранение и отмену улетевших Future;
      // Но если нужно, вы скажите. Доделаю.
      if (filesPoll[fileInfo.id] != null) {
        filesPoll[fileInfo.id] = fileInfo;
        _notify();
      }
    });
  }

  final UploaderService uploaderService;
  Map<String, FileInfo> filesPoll = {};

  late StreamController<List<FileInfo>> controller;

  @override
  Stream<List<FileInfo>> get fileInfos => controller.stream;

  @override
  void dequeue(String id) {
    final FileInfo? file = filesPoll[id];
    if (file != null) {
      final fileToRemove = filesPoll.remove(id);
      if (fileToRemove != null) {
        uploaderService.dequeue(fileToRemove);
        _notify();
      }
    }
  }

  @override
  void enqueue(List<FileInfo> files) async {
    // Где-то тут можно было бы пробросить сообщение, что данный файл уже добавлен, например,
    // Через CustomException, определенный на domain-уровне uploader модуля, который может
    // обработать наш Bloc;
    final notAddedFiles =
        files.where((file) => !filesPoll.containsKey(file.id)).toList();

    for (var file in notAddedFiles) {
      filesPoll[file.id] = file;
      _notify();
    }
    uploaderService.enqueue(notAddedFiles);
  }

  @override
  void clear() {
    filesPoll.clear();
    uploaderService.clean();
    _notify();
  }

  void _notify() {
    controller.sink.add(filesPoll.values.toList());
  }
}
