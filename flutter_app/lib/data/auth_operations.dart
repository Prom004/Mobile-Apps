import 'package:flutter_app/data/notifiers.dart';

class AuthOperations {
  // Demo users for testing (in a real app, this would be a backend API)
  // static final Map<String, String> _demoUsers = {
  //   'admin@todo.com': 'admin123',
  //   'user@todo.com': 'user123',
  //   'demo@todo.com': 'demo123',
  //   'test@todo.com': 'test123',
  // };

  // Registered users storage (in a real app, this would be a database)
  static final Map<String, Map<String, String>> _registeredUsers = {};

  // Login function
  static Future<bool> login(String email, String password) async {
    isLoadingNotifier.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      final emailLower = email.toLowerCase();
      String? userName;

      // Check demo users first
      // if (_demoUsers.containsKey(emailLower) &&
      //     _demoUsers[emailLower] == password) {
      //   userName = _getNameFromEmail(email);
      // }
      // Check registered users
      if (_registeredUsers.containsKey(emailLower) &&
               _registeredUsers[emailLower]!['password'] == password) {
        userName = _registeredUsers[emailLower]!['name']!;
      }

      if (userName != null) {
        // Create user object
        final user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: emailLower,
          name: userName,
          loginTime: DateTime.now(),
        );

        // Set current user
        currentUserNotifier.value = user;
        isLoadingNotifier.value = false;
        return true;
      } else {
        isLoadingNotifier.value = false;
        return false;
      }
    } catch (e) {
      isLoadingNotifier.value = false;
      return false;
    }
  }

  // Register function
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    isLoadingNotifier.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      final emailLower = email.toLowerCase();

      // Check if user already exists
      // if (_demoUsers.containsKey(emailLower) || _registeredUsers.containsKey(emailLower)) {
      //   isLoadingNotifier.value = false;
      //   return {
      //     'success': false,
      //     'message': 'An account with this email already exists.',
      //   };
      // }

      // Validate input
      if (name.trim().length < 2) {
        isLoadingNotifier.value = false;
        return {
          'success': false,
          'message': 'Name must be at least 2 characters long.',
        };
      }

      if (!isValidEmail(email)) {
        isLoadingNotifier.value = false;
        return {
          'success': false,
          'message': 'Please enter a valid email address.',
        };
      }

      if (password.length < 6) {
        isLoadingNotifier.value = false;
        return {
          'success': false,
          'message': 'Password must be at least 6 characters long.',
        };
      }

      // Register the user
      _registeredUsers[emailLower] = {
        'name': name.trim(),
        'password': password,
        'registeredAt': DateTime.now().toIso8601String(),
      };

      // Create user object and log them in
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: emailLower,
        name: name.trim(),
        loginTime: DateTime.now(),
      );

      // Set current user
      currentUserNotifier.value = user;
      isLoadingNotifier.value = false;

      return {
        'success': true,
        'message': 'Account created successfully! Welcome to Todo App.',
      };
    } catch (e) {
      isLoadingNotifier.value = false;
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Logout function
  static void logout() {
    currentUserNotifier.value = null;
    // Reset todo data when logging out
    todoListNotifier.value = [
      Todo(id: 1, title: 'Learn Flutter', isCompleted: false, createdAt: DateTime.now()),
      Todo(id: 2, title: 'Build Todo App', isCompleted: false, createdAt: DateTime.now()),
      Todo(id: 3, title: 'Add Dark Mode', isCompleted: true, createdAt: DateTime.now()),
    ];
    searchQueryNotifier.value = '';
    selectedPageNotifier.value = 0;
  }

  // Check if user is logged in
  static bool get isLoggedIn => currentUserNotifier.value != null;

  // Get current user
  static User? get currentUser => currentUserNotifier.value;

  // Helper function to extract name from email
  static String _getNameFromEmail(String email) {
    final username = email.split('@')[0];
    return username.split('.').map((part) => 
      part[0].toUpperCase() + part.substring(1)
    ).join(' ');
  }

  // Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Get demo credentials for testing
  // static List<Map<String, String>> getDemoCredentials() {
  //   return _demoUsers.entries.map((entry) => {
  //     'email': entry.key,
  //     'password': entry.value,
  //   }).toList();
  // }

  // Check if email is already registered
  // static bool isEmailRegistered(String email) {
  //   final emailLower = email.toLowerCase();
  //   return _demoUsers.containsKey(emailLower) || _registeredUsers.containsKey(emailLower);
  // }

  // Get total registered users count
  static int get registeredUsersCount => _registeredUsers.length;

  // Validate password strength
  static Map<String, dynamic> validatePassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));

    final score = [hasMinLength, hasUppercase, hasLowercase, hasNumbers]
        .where((condition) => condition).length;

    String strength;
    if (score <= 1) {
      strength = 'Weak';
    } else if (score <= 2) {
      strength = 'Fair';
    } else if (score <= 3) {
      strength = 'Good';
    } else {
      strength = 'Strong';
    }

    return {
      'isValid': hasMinLength,
      'strength': strength,
      'score': score,
      'suggestions': [
        if (!hasMinLength) 'At least 6 characters',
        if (!hasUppercase) 'One uppercase letter',
        if (!hasLowercase) 'One lowercase letter',
        if (!hasNumbers) 'One number',
      ],
    };
  }

  static bool isEmailRegistered(String email) {
    final emailLower = email.toLowerCase();
    return _registeredUsers.containsKey(emailLower);
  }
}
