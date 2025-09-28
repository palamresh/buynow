import 'package:buynow/features2/learn_hive/note_model.dart';
import 'package:hive/hive.dart';

class Boxs {
  static Box<NoteModel> getData() => Hive.box<NoteModel>("notes");
}
