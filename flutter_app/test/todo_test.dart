import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/data/notifiers.dart';
import 'package:flutter_app/data/todo_operations.dart';

void main() {
  group('Todo Operations Tests', () {
    setUp(() {
      // Reset the todo list before each test
      todoListNotifier.value = [
        Todo(id: 1, title: 'Test Todo 1', isCompleted: false, createdAt: DateTime.now()),
        Todo(id: 2, title: 'Test Todo 2', isCompleted: true, createdAt: DateTime.now()),
      ];
      searchQueryNotifier.value = '';
    });

    test('should add a new todo', () {
      final initialCount = todoListNotifier.value.length;
      TodoOperations.addTodo('New Test Todo');
      
      expect(todoListNotifier.value.length, initialCount + 1);
      expect(todoListNotifier.value.first.title, 'New Test Todo');
      expect(todoListNotifier.value.first.isCompleted, false);
    });

    test('should not add empty todo', () {
      final initialCount = todoListNotifier.value.length;
      TodoOperations.addTodo('');
      TodoOperations.addTodo('   ');
      
      expect(todoListNotifier.value.length, initialCount);
    });

    test('should toggle todo completion', () {
      final todoId = todoListNotifier.value.first.id;
      final initialStatus = todoListNotifier.value.first.isCompleted;
      
      TodoOperations.toggleTodo(todoId);
      
      final updatedTodo = todoListNotifier.value.firstWhere((todo) => todo.id == todoId);
      expect(updatedTodo.isCompleted, !initialStatus);
    });

    test('should delete todo', () {
      final todoId = todoListNotifier.value.first.id;
      final initialCount = todoListNotifier.value.length;
      
      TodoOperations.deleteTodo(todoId);
      
      expect(todoListNotifier.value.length, initialCount - 1);
      expect(todoListNotifier.value.any((todo) => todo.id == todoId), false);
    });

    test('should filter todos by search query', () {
      TodoOperations.updateSearchQuery('Test Todo 1');
      final filteredTodos = TodoOperations.getFilteredTodos();
      
      expect(filteredTodos.length, 1);
      expect(filteredTodos.first.title, 'Test Todo 1');
    });

    test('should return correct statistics', () {
      final stats = TodoOperations.getStats();
      
      expect(stats['total'], 2);
      expect(stats['completed'], 1);
      expect(stats['pending'], 1);
    });

    test('should clear completed todos', () {
      TodoOperations.clearCompleted();
      
      expect(todoListNotifier.value.length, 1);
      expect(todoListNotifier.value.every((todo) => !todo.isCompleted), true);
    });
  });
}
