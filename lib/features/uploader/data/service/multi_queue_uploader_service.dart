import 'dart:async';
import 'dart:math';
import 'package:test_task_xdevteam/features/uploader/data/service/uploader_service.dart';
import 'package:test_task_xdevteam/features/uploader/data/task_runner/task_runner.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/status.dart';

class MultiQueueUploaderService extends UploaderService {
  late TaskRunner<FileInfo, FileInfo> taskRunner;

  MultiQueueUploaderService() {
    controller = StreamController<FileInfo>();
  }

  @override
  Stream<FileInfo> get filesInfo => controller.stream;

  late StreamController<FileInfo> controller;

  @override
  void dequeue(FileInfo file) {
    taskRunner.remove(file);
  }

  @override
  void enqueue(List<FileInfo> files) {
    taskRunner.addAll(files);
  }

  @override
  void clean() {
    taskRunner.clear();
  }

  @override
  void init() {
    final Random random = Random();

    Future<FileInfo> before(FileInfo fileInfo) => Future(() {
          return fileInfo.copyWith(status: Status.uploading);
        });

    // Место для отправки на сервер. Любая Future на выбор.
    // От responce зависит статус, как по мне, нужно еще добавить "not_loaded", если не получилось загрузить.
    // Я не стал делать отдельный HTTP-сервис и делать фейк прямо в нем, но если нужно,
    // могу сделать и его.

    // Осталось:
    // 1. Забрать файл: final File file = File(fileInfo.path);
    // 2. Собрать запрос.
    // Выполнить его в раннере ниже.

    Future<FileInfo> upload(FileInfo fileInfo) => Future.delayed(
          Duration(seconds: random.nextInt(15)),
          () => fileInfo.copyWith(status: Status.uploaded),
        );

    taskRunner = TaskRunner<FileInfo, FileInfo>(
      before: before,
      task: upload,
      maxConcurrentTasks: 2,
    );

    taskRunner.stream.listen((fileInfo) {
      controller.add(fileInfo);
    });
  }
}
