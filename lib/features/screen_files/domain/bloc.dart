import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/event.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/model/files_info.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/state.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/event.dart'
    as uploader_event;
import 'package:test_task_xdevteam/features/uploader/domain/bloc/state.dart'
    as uploader_state;
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

class FilesScreenBloc extends Bloc<FilesScreenEvent, FilesScreenState> {
  FilesScreenBloc({
    required this.uploaderBloc,
  }) : super(OnLoading()) {
    _uploaderBlocSubscription = uploaderBloc.stream.listen((state) {
      print("event: ${state.toString()}");
      handleUploaderState(state);
    });

    on<FilesOpened>((event, emit) {
      handleUploaderState(uploaderBloc.state);
    });

    on<EnqueueFiles>((event, emit) {
      try {
        final List<FileInfo> files = event.paths
            .where((path) => path != null)
            .map((path) => FileInfo.newFile(
                  name: path!.split("/").last,
                  id: path,
                  path: path,
                ))
            .toList();
        uploaderBloc.add(uploader_event.Enqueue(files: files));
      } catch (e) {
        emit(OnError());
      }
    });

    on<DequeueFile>((event, emit) {
      uploaderBloc.add(uploader_event.Dequeue(fileUid: event.id));
    });
  }

  late StreamSubscription _uploaderBlocSubscription;
  final UploaderBloc uploaderBloc;

  @override
  Future<void> close() async {
    _uploaderBlocSubscription.cancel();
    super.close();
  }

  void handleUploaderState(uploader_state.UploaderState state) {
    if (state is uploader_state.UploadedFiles) {
      emit(
          OnFilesViewState(filesInfo: FilesScreenInfo(filesInfo: state.files)));
    } else if (state is uploader_state.UploaderInitialization) {
      emit(OnLoading());
    } else if (state is uploader_state.UploaderError) {
      emit(OnError());
    }
  }
}
