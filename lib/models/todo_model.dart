import 'package:firebase_storage/firebase_storage.dart';

class TodoModel {
  final String todoId;
  final String assignedBy;
  String todoTitle;
  final String deadline;
  String taskDescription;
  List taskList;
  final List people;
  final int progress;
  final String createrUid;
  final bool isFromGroup;
  final String groupId;

  TodoModel({
    required this.todoId,
    required this.assignedBy,
    required this.todoTitle,
    required this.deadline,
    required this.taskDescription,
    required this.taskList,
    required this.people,
    this.progress = 0,
    required this.createrUid,
    required this.isFromGroup,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'todoId': todoId,
      'assignedBy': assignedBy,
      'todoTitle': todoTitle,
      'deadline': deadline,
      'taskDescription': taskDescription,
      'taskList': taskList,
      'people': people,
      'progress': progress,
      'createrUid': createrUid,
      'isFromGroup': isFromGroup,
      'groupId': groupId,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      todoId: map['todoId'],
      assignedBy: map['assignedBy'],
      todoTitle: map['todoTitle'],
      deadline: map['deadline'],
      taskDescription: map['taskDescription'],
      taskList: map['taskList'],
      people: map['people'],
      progress: map['progress'],
      createrUid: map['createrUid'] ?? "0",
      isFromGroup: map['isFromGroup'] ?? false,
      groupId: map['groupId'] ?? "",
    );
  }
}

class TaskModel {
  final String taskId;
  bool isCompleted;
  String taskTitle;
  DateTime? completedAt;

  TaskModel({
    required this.taskId,
    required this.isCompleted,
    required this.taskTitle,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'isCompleted': isCompleted,
      'taskTitle': taskTitle,
      'completedAt': completedAt,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      isCompleted: map['isCompleted'],
      taskTitle: map['taskTitle'],
      completedAt:
          map['completedAt'] != null ? map['completedAt'].toDate() : null,
    );
  }
}
