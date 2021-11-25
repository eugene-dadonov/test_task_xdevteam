import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/core/strings.dart';
import 'package:test_task_xdevteam/core/styles.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/bloc.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/event.dart';
import 'package:test_task_xdevteam/features/screen_files/domain/state.dart';
import 'package:test_task_xdevteam/features/screen_files/presentation/widget/file_item.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import 'package:test_task_xdevteam/features/uploader/domain/entity/file_info.dart';

class FilesPage extends StatelessWidget {
  const FilesPage({Key? key}) : super(key: key);

  static Widget view({
    required UploaderBloc uploaderBloc,
  }) {
    return BlocProvider.value(
      value: uploaderBloc,
      child: BlocProvider<FilesScreenBloc>(
          create: (context) =>
              FilesScreenBloc(uploaderBloc: uploaderBloc)..add(FilesOpened()),
          child: const FilesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          AppLocalization.titleFiles,
          style: AppStyles.h1,
        ),
      ),
      body: BlocBuilder<FilesScreenBloc, FilesScreenState>(
        builder: (context, state) {
          print("files page" + state.toString());
          if (state is OnLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OnFilesViewState) {
            return FilesView(fileInfos: state.filesInfo.filesInfo);
          } else if (state is OnError) {
            return const Center(
                child: Text(AppLocalization.errorWhileLoadingInfo));
          } else {
            return const Center(
                child: Text(AppLocalization.errorUnknownException));
          }
        },
      ),
      floatingActionButton: BlocBuilder<FilesScreenBloc, FilesScreenState>(
        builder: (context, state) {
          if (state is OnFilesViewState &&
              state.filesInfo.filesInfo.length < 30) {
            return FloatingActionButton(
                child: const Icon(Icons.upload_file),
                onPressed: () async {
                  selectFile.call(context);
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

void selectFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) {
    try {
      context
          .read<FilesScreenBloc>()
          .add(EnqueueFiles(paths: result.paths));
    } catch (e) {
      const snackBar = SnackBar(content: Text(AppLocalization.errorWhileChoosingFile));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class FilesView extends StatelessWidget {
  const FilesView({Key? key, required this.fileInfos}) : super(key: key);

  final List<FileInfo> fileInfos;

  @override
  Widget build(BuildContext context) {
    if (fileInfos.isEmpty) {
      return const Center(
        child: Text(
          AppLocalization.titleNoFiles,
          style: AppStyles.h2,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: fileInfos.length,
        itemBuilder: (context, index) {
          return FileInfoWidget(
            fileInfo: fileInfos[index],
            onDelete: (String value) {
              // Давайте представим, что тут есть Alert-диалог;
              context
                  .read<FilesScreenBloc>()
                  .add(DequeueFile(id: fileInfos[index].id));
            },
          );
        },
      );
    }
  }
}
