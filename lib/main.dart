import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/splash/screen/splash_screen.dart';
import 'package:buynow/features2/learn_hive/hive_screen.dart';
import 'package:buynow/features2/learn_hive/note_model.dart';
import 'package:buynow/features2/learn_hive/notes_screen.dart';
import 'package:buynow/features2/platform_specific_code/get_battery_screen.dart';
import 'package:buynow/features2/video/better_play_screen.dart';
import 'package:buynow/features2/video/download_screen.dart';
import 'package:buynow/features2/video/video_play_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter<NoteModel>(NoteModelAdapter());
  await Hive.openBox<NoteModel>("notes");
  // databaseFactory = databaseFactoryFfi;

  await DbHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BuyNow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: SplashScreen(),
      // home: NotesScreen(),
      // home: GetBatteryScreen(),
      // home: VideoPlayScreen(),
      // home: BetterPlayerPlusExample(),
      home: VideoDownloadScreen(),
    );
  }
}
