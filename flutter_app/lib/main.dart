import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/notifiers.dart';
import 'package:flutter_app/views/auth_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide system UI overlays (status bar, navigation bar) for a cleaner look
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyAppState());
}

class MyAppState extends StatefulWidget {
  const MyAppState({super.key});


  @override
  State<MyAppState> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              ),
            useMaterial3: true,
            // Remove any default app bar styling that might show warnings
            // appBarTheme: const AppBarTheme(
            //   systemOverlayStyle: SystemUiOverlayStyle.light,
            // ),
          ),
          home: const AuthWrapper(),
          // Additional debug configurations
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Remove any text scaling that might cause layout warnings
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}