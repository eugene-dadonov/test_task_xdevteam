import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/event.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/state.dart';
import 'package:test_task_xdevteam/features/uploader/domain/repository/uploader.dart';

class UploaderBloc extends Bloc<UploaderEvent, UploaderState> {
  UploaderBloc({
    required this.uploader,
  }) : super(UploaderInitialization()) {
    _uploaderBlocSubscription = uploader.fileInfos.listen((fileInfos) {
      print("UploaderBloc: ${fileInfos.length}");
      emit(UploadedFiles(files: fileInfos));
    });

    on<Enqueue>((event, emit) => uploader.enqueue(event.files));
    on<Dequeue>((event, emit) => uploader.dequeue(event.fileUid));
    on<ClearQueue>((event, emit) => uploader.clear());
  }

  late StreamSubscription _uploaderBlocSubscription;
  final RepositoryUploader uploader;

  @override
  Future<void> close() async {
    _uploaderBlocSubscription.cancel();
    super.close();
  }
}
