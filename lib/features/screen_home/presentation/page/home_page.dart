import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/core/strings.dart';
import 'package:test_task_xdevteam/core/styles.dart';
import 'package:test_task_xdevteam/features/screen_home/domain/bloc/bloc.dart';
import 'package:test_task_xdevteam/features/screen_home/domain/bloc/event.dart';
import 'package:test_task_xdevteam/features/screen_home/domain/bloc/state.dart';
import 'package:test_task_xdevteam/features/screen_home/domain/model/files_info.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import '../../../../routes.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static Widget view({
    required UploaderBloc uploaderBloc,
  }) {
    return BlocProvider.value(
      value: uploaderBloc,
      child: BlocProvider<HomeScreenBloc>(
          create: (context) =>
              HomeScreenBloc(uploaderBloc: uploaderBloc)..add(HomeOpened()),
          child: const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppLocalization.titleHome,
          style: AppStyles.h1,
        ),
      ),
      body: BlocConsumer<HomeScreenBloc, HomeScreenState>(
        listenWhen: (context, state) =>
            state is OnSaveFiles || state is OnNavigateToFiles,
        listener: (context, state) {
          if (state is OnSaveFiles) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  AppLocalization.titleFilesUploaded,
                  style: AppStyles.h1,
                ),
              ),
            );
          } else if (state is OnNavigateToFiles) {
            Navigator.pushNamed(context, Routes.files);
          }
        },
        buildWhen: (context, state) =>
            state is OnViewLoading || state is OnError || state is OnViewState,
        builder: (context, state) {
          if (state is OnViewLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OnViewState) {
            return Column(
              children: [
                Expanded(child: MenuList(filesInfo: state.filesInfo)),
                OperationButtons(filesInfo: state.filesInfo),
              ],
            );
          } else if (state is OnError) {
            return Center(
              child:
                  Text(state.message ?? AppLocalization.errorWhileLoadingInfo),
            );
          } else {
            return const Center(
              child: Text(AppLocalization.errorUnknownException),
            );
          }
        },
      ),
    );
  }
}

// Выношу вью в отдельные Widget'ы, которые будут инкапсулировать в себе логику.
// Не очень люблю методы build/generateAnything, они выглядят как антипаттерн во Flutter;
class MenuList extends StatelessWidget {
  const MenuList({
    Key? key,
    required this.filesInfo,
  }) : super(key: key);

  final HomeScreenInfo filesInfo;

  @override
  Widget build(BuildContext context) {
    // Ну вот тут вопрос, можно сделать очень многими способами, зависит от количества
    // элементов меню. Плюсом, зачастую, они формируются программно от данных, ролей и так далее.
    // Можно сделать и SliverList, и CustomScrollView с Column.
    // Если бы это был реальный проект, разбил бы всю страницу на разные view;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        MenuItem(filesInfo: filesInfo),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.filesInfo,
  }) : super(key: key);
  final HomeScreenInfo filesInfo;

  @override
  Widget build(BuildContext context) {
    final title = filesInfo.activeFilesCount > 0
        ? AppLocalization.titleLoadedAndActiveFilesCount(
            activeCount: filesInfo.activeFilesCount,
            allCount: filesInfo.filesCount)
        : AppLocalization.titleLoadedFilesCount(count: filesInfo.filesCount);
    return ListTile(
      title: const Text(AppLocalization.titleFiles, style: AppStyles.h2),
      subtitle: Text(
          filesInfo.filesCount == 0 ? AppLocalization.titleNoFiles : title,
          style: AppStyles.h3),
      trailing:
          const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black38),
      onTap: () {
        context.read<HomeScreenBloc>().add(NavigateToFiles());
      },
    );
  }
}

class OperationButtons extends StatelessWidget {
  const OperationButtons({
    Key? key,
    required this.filesInfo,
  }) : super(key: key);

  final HomeScreenInfo filesInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextButton(
              onPressed:
                  filesInfo.isResetAvailable ? () => reset.call(context) : null,
              child: const Text(
                AppLocalization.buttonReset,
                style: AppStyles.h2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextButton(
              onPressed:
                  filesInfo.isSaveAvailable ? () => save.call(context) : null,
              child: const Text(
                AppLocalization.buttonSave,
                style: AppStyles.h2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void save(BuildContext context) {
    context.read<HomeScreenBloc>().add(SaveFiles());
  }

  void reset(BuildContext context) {
    context.read<HomeScreenBloc>().add(ResetFiles());
  }
}
