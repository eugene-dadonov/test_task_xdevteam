import 'dart:async';
import 'dart:collection';

// За основу взят этот раннер: https://stackoverflow.com/questions/62878704/how-to-implement-an-async-task-queue-with-multiple-concurrent-workers-async-in
// Но как оказалось, я не то чтобы не отделался малой кровью, но после дебага выяснилось, что он нерабочий.
// Поэтому этот на 90% мой.
class TaskRunner<I, O> {
  final Queue<I> _input = Queue();
  final StreamController<O> _outputStreamController = StreamController();
  final StreamController<O> _queueNotifier = StreamController();

  final Future<O> Function(I) task;
  final Future<O> Function(I)? before;
  // Тут может быть after, но мне он не к чему тут.

  final int maxConcurrentTasks;
  int runningTasks = 0;

  // Вообще, по-хорошему, нужно добавить удаление/таймаут для уже улетевших
  // Future, чтобы они не тратили время на загрузку, а сразу приступали к новой.

  TaskRunner({
    this.maxConcurrentTasks = 3,
    this.before,
    required this.task,
  }) {
    _queueNotifier.stream.listen((event) {
      runningTasks--;
      print("Закончено");
      _checkQueue();
    });
  }

  Stream<O> get stream => _outputStreamController.stream;

  void add(I value) {
    _input.add(value);
    _checkQueue();
  }

  void remove(I value) {
    _input.remove(value);
  }

  void clear() {
    _input.clear();
  }

  void addAll(Iterable<I> iterable) {
    _input.addAll(iterable);
    _checkQueue();
  }

  void _checkQueue() {
    print("Проверка очереди");
    if (_input.isEmpty || runningTasks == maxConcurrentTasks) {
      print("Очередь пуста или все воркеры заняты");
      return;
    } else {
      print("Начало выполнения задачи");
      while (runningTasks != maxConcurrentTasks && _input.isNotEmpty) {
        if (_input.isNotEmpty) {
          doTask(_input.removeFirst());
        }
      }
    }
  }

  Future<void> doTask(I item) async {
    print("Добавление таска");
    runningTasks++;

    final beforeResult = await before?.call(item);
    if (before != null && beforeResult != null) {
      print("Before закончен");
      _outputStreamController.add(beforeResult);
    }

    final result = await task.call(item);
    print("Такс закончен");
    _outputStreamController.add(result);
    _queueNotifier.add(result);
  }
}
