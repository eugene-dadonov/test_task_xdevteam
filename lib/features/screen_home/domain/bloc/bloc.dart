import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/features/screen_home/domain/model/files_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/event.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/state.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/status.dart';
import 'event.dart';
import 'state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc({
    required this.uploaderBloc,
  }) : super(OnViewLoading()) {
    _uploaderBlocSubscription = uploaderBloc.stream.listen((state) {
      if (state is UploadedFiles) {
        emit(OnViewState(
          filesInfo: state.files.toHomeScreenInfo(),
        ));
      }
    });

    on<HomeOpened>((event, emit) {
      _updateScreen(emit, uploaderBloc.state);
    });

    on<SaveFiles>((event, emit) {
      emit(OnSaveFiles());
    });

    on<NavigateToFiles>((event, emit) {
      emit(OnNavigateToFiles());
    });

    on<ResetFiles>((event, emit) {
      uploaderBloc.add(ClearQueue());
    });
  }

  late StreamSubscription _uploaderBlocSubscription;
  final UploaderBloc uploaderBloc;

  @override
  Future<void> close() async {
    _uploaderBlocSubscription.cancel();
    super.close();
  }

  void _updateScreen(
    Emitter<HomeScreenState> emit,
    UploaderState uploaderBlocState,
  ) {
    if (uploaderBlocState is UploadedFiles) {
      emit(OnViewState(filesInfo: uploaderBlocState.files.toHomeScreenInfo()));
    } else if (uploaderBlocState is UploaderInitialization) {
    } else if (uploaderBlocState is UploaderError) {}
  }
}

extension FilesX on List<FileInfo> {
  HomeScreenInfo toHomeScreenInfo() {
    final uploadingFiles =
        where((file) => file.status == Status.uploading).length;
    final waitingFiles = where((file) => file.status == Status.waiting).length;
    final activeFilesCount = uploadingFiles + waitingFiles;

    return HomeScreenInfo(
      isSaveAvailable: isNotEmpty && activeFilesCount == 0,
      isResetAvailable: isNotEmpty,
      filesCount: length,
      activeFilesCount: activeFilesCount,
    );
  }
}
