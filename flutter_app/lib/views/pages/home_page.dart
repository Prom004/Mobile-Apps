import 'package:flutter/material.dart';
import 'package:flutter_app/data/notifiers.dart';
import 'package:flutter_app/data/todo_operations.dart';
import 'package:flutter_app/data/auth_operations.dart';
import 'package:flutter_app/widgets/todo_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_taskController.text.trim().isNotEmpty) {
      TodoOperations.addTodo(_taskController.text);
      _taskController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Enter your task...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _addTodo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder<String>(
                  valueListenable: searchQueryNotifier,
                  builder: (context, query, child) {
                    return query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              TodoOperations.clearSearch();
                            },
                          )
                        : const SizedBox.shrink();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: TodoOperations.updateSearchQuery,
            ),
          ),

          // Stats Row
          ValueListenableBuilder<List<Todo>>(
            valueListenable: todoListNotifier,
            builder: (context, todos, child) {
              final stats = TodoOperations.getStats();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard('Total', stats['total']!, Colors.blue),
                        _buildStatCard('Pending', stats['pending']!, Colors.orange),
                        _buildStatCard('Completed', stats['completed']!, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Quick Actions Row
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () => _showLogoutDialog(),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // children: [
                                  //   Icon(Icons.logout, color: Colors.red, size: 20),
                                  //   const SizedBox(width: 8),
                                  //   Text(
                                  //     'Logout',
                                  //     style: TextStyle(
                                  //       color: Colors.red,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => TodoOperations.clearCompleted(),
                            icon: Icon(Icons.clear_all, color: Colors.orange),
                            label: Text(
                              'Clear Done',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Todo List
          Expanded(
            child: ValueListenableBuilder<List<Todo>>(
              valueListenable: todoListNotifier,
              builder: (context, todos, child) {
                return ValueListenableBuilder<String>(
                  valueListenable: searchQueryNotifier,
                  builder: (context, query, child) {
                    final filteredTodos = TodoOperations.getFilteredTodos();

                    if (filteredTodos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              query.isNotEmpty ? Icons.search_off : Icons.task_alt,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              query.isNotEmpty
                                  ? 'No todos found for "$query"'
                                  : 'No todos yet!\nTap + to add your first task',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        return TodoItemWidget(
                          todo: todo,
                          onToggle: () => TodoOperations.toggleTodo(todo.id),
                          onDelete: () => TodoOperations.deleteTodo(todo.id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthOperations.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}