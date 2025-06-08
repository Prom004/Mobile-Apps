import 'package:flutter_app/data/notifiers.dart';

class TodoOperations {
  static int _nextId = 4; // Starting from 4 since we have 3 initial todos

  // Add a new todo
  static void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: _nextId++,
      title: title.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    final currentList = List<Todo>.from(todoListNotifier.value);
    currentList.insert(0, newTodo); // Add to the beginning
    todoListNotifier.value = currentList;
  }

  // Toggle todo completion status
  static void toggleTodo(int id) {
    final currentList = List<Todo>.from(todoListNotifier.value);
    final index = currentList.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      currentList[index] = currentList[index].copyWith(
        isCompleted: !currentList[index].isCompleted,
      );
      todoListNotifier.value = currentList;
    }
  }

  // Delete a todo
  static void deleteTodo(int id) {
    final currentList = List<Todo>.from(todoListNotifier.value);
    currentList.removeWhere((todo) => todo.id == id);
    todoListNotifier.value = currentList;
  }

  // Get filtered todos based on search query
  static List<Todo> getFilteredTodos() {
    final todos = todoListNotifier.value;
    final query = searchQueryNotifier.value.toLowerCase();

    if (query.isEmpty) {
      return todos;
    }

    return todos.where((todo) {
      return todo.title.toLowerCase().contains(query);
    }).toList();
  }

  // Update search query
  static void updateSearchQuery(String query) {
    searchQueryNotifier.value = query;
  }

  // Clear search
  static void clearSearch() {
    searchQueryNotifier.value = '';
  }

  // Get statistics
  static Map<String, int> getStats() {
    final todos = todoListNotifier.value;
    final total = todos.length;
    final completed = todos.where((todo) => todo.isCompleted).length;
    final pending = total - completed;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }

  // Clear all completed todos
  static void clearCompleted() {
    final currentList = List<Todo>.from(todoListNotifier.value);
    currentList.removeWhere((todo) => todo.isCompleted);
    todoListNotifier.value = currentList;
  }
}
