import 'package:flutter/material.dart';
import 'package:flutter_app/utils/todo_list.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List todoList = [
    [ 'Learn flutter', false],
    ['Complete TypeScript', false]
  ]; 

  void checkBoxChanged(int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  void saveNewTask () {
    setState(() {
      todoList.add([_controller.text, false]);
      _controller.clear();
    });
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(title: const Text('Simple To Do'),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: todoList.length, 
        itemBuilder: (BuildContext context, index) {
        return TodoList(
          taskName: todoList[index][0],
          taskComplete: todoList[index][1],
          onChanged: (value) => checkBoxChanged(index),
          deleteFunction:(context) => deleteTask(index),
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add more tasks',
                    filled: true,
                    fillColor: Colors.deepPurple.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple
                      ),
                    borderRadius: BorderRadius.circular(15)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
                      ),
                    borderRadius: BorderRadius.circular(15)
                    )
                  ),
                ),
              ),
              ),
            FloatingActionButton(
              onPressed: saveNewTask,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
