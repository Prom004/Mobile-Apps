import 'package:flutter/material.dart';
import 'package:flutter_app/data/notifiers.dart';
import 'package:flutter_app/views/pages/auth_page.dart';
import 'package:flutter_app/views/widget_tree.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: currentUserNotifier,
      builder: (context, user, child) {
        if (user != null) {
          // User is logged in, show main app
          return const WidgetTree();
        } else {
          // User is not logged in, show auth page (login/register)
          return const AuthPage();
        }
      },
    );
  }
}
