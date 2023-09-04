import 'package:hive/hive.dart';

part 'hive_db.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime lastUpdated;

  NotesModel({
    required this.title,
    required this.content,
    required this.lastUpdated,
  });
}