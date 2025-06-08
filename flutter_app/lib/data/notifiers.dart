import 'package:flutter/foundation.dart';

// Navigation and theme notifiers
ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

// User authentication data
class User {
  final String id;
  final String email;
  final String name;
  final DateTime loginTime;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.loginTime,
  });
}

// Authentication notifiers
ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);
ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

// Todo app data
class Todo {
  final int id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  Todo copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Todo notifiers
ValueNotifier<List<Todo>> todoListNotifier = ValueNotifier<List<Todo>>([
  Todo(id: 1, title: 'Learn Flutter', isCompleted: false, createdAt: DateTime.now()),
  Todo(id: 2, title: 'Build Todo App', isCompleted: false, createdAt: DateTime.now()),
  Todo(id: 3, title: 'Add Dark Mode', isCompleted: true, createdAt: DateTime.now()),
]);

ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');