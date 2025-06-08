import 'package:flutter/material.dart';
import 'package:flutter_app/views/pages/home_page.dart';
import 'package:flutter_app/views/pages/profile_page.dart';
import 'package:flutter_app/widgets/navbar_widget.dart';

List<Widget> pages = [
  HomePage(),
  ProfilePage()
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My flutter App'),
          centerTitle: true,
        ),
        body: pages.elementAt(1),
        bottomNavigationBar: NavbarWidget(),
      );
  }
}