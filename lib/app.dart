import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_xdevteam/features/uploader/domain/bloc/bloc.dart';
import 'package:test_task_xdevteam/routes.dart';

import 'features/screen_files/presentation/page/files_page.dart';
import 'features/screen_home/presentation/page/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Anything in 15 seconds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.blueGrey[50],
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => MyHomePage.view(
            uploaderBloc: BlocProvider.of<UploaderBloc>(context)),
        Routes.files: (context) => FilesPage.view(
            uploaderBloc: BlocProvider.of<UploaderBloc>(context)),
      },
    );
  }
}
