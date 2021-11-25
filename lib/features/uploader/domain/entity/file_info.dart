import 'status.dart';

class FileInfo {
  final String id;
  final Status status;
  final String name;
  final String path;
  final DateTime addedDate;

  FileInfo({
    required this.id,
    required this.status,
    required this.name,
    required this.path,
    required this.addedDate,
  });

  FileInfo.newFile({
    required this.id,
    required this.name,
    required this.path,
  })  : status = Status.waiting,
        addedDate = DateTime.now();

  FileInfo copyWith({
    String? id,
    Status? status,
    String? name,
    String? path,
    DateTime? addedDate,
  }) {
    return FileInfo(
      id: id ?? this.id,
      status: status ?? this.status,
      name: name ?? this.name,
      path: path ?? this.path,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
