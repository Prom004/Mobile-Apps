import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key, 
    required this.taskName,
    required this.taskComplete,
    required this.onChanged, 
    required this.deleteFunction
    });

  final String taskName;
  final bool taskComplete;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(), 
          children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(15),
            backgroundColor: Colors.red,
          )]
          ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple, // ✅ Use color here only
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                value: taskComplete, 
                onChanged: onChanged,
                checkColor: Colors.black,
                // fillColor: Colors.black,
                activeColor: Colors.white,
                side: BorderSide(
                  color: Colors.white
                ),
                ),
              Text(
                taskName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration:
                    taskComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                  decorationThickness: 2
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
