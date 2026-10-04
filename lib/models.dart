import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class CheckIn {
  @HiveField(0)
  String time;

  @HiveField(1)
  String mood;

  @HiveField(2)
  String note;

  CheckIn({
    required this.time,
    required this.mood,
    required this.note,
  });
}

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool completed;

  Task({
    required this.title,
    this.completed = false,
  });
}

@HiveType(typeId: 2)
class Daylog {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<CheckIn> checkIns;

  @HiveField(2)
  List<Task> tasks;

  @HiveField(3)
  String journal;

  Daylog({
    required this.date,
    required this.checkIns,
    required this.tasks,
    required this.journal,
  });
}