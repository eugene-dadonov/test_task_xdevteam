import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/app.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import 'features/uploader/data/service/multi_queue_uploader_service.dart';
import 'features/uploader/data/uploader/file_uploader.dart';

void main() {
  runApp(
    const _ServicesProvider(
      child: _RepositoriesProvider(
        child: _BlocProvider(
          child: MyApp(),
        ),
      ),
    ),
  );
}

class _ServicesProvider extends StatelessWidget {
  final Widget child;

  const _ServicesProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MultiQueueUploaderService(),
      child: child,
    );
  }
}

class _RepositoriesProvider extends StatelessWidget {
  final Widget child;

  const _RepositoriesProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FileUploaderRepository(
          uploaderService: context.read<MultiQueueUploaderService>()..init()),
      child: child,
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          UploaderBloc(uploader: context.read<FileUploaderRepository>()),
      child: child,
    );
  }
}
