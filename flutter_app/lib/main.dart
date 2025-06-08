import 'package:flutter/material.dart';
import 'package:flutter_app/views/widget_tree.dart';


class MyAppState extends StatefulWidget {
  const MyAppState({super.key});


  @override
  State<MyAppState> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          )
      ),
      home: WidgetTree(),
    );
  }
}