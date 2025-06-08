import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/data/notifiers.dart';
import 'package:flutter_app/data/auth_operations.dart';

void main() {
  group('Authentication Tests', () {
    setUp(() {
      // Reset authentication state before each test
      currentUserNotifier.value = null;
      isLoadingNotifier.value = false;
    });

    test('should login with valid credentials', () async {
      final result = await AuthOperations.login('demo@todo.com', 'demo123');
      
      expect(result, true);
      expect(AuthOperations.isLoggedIn, true);
      expect(AuthOperations.currentUser?.email, 'demo@todo.com');
      expect(AuthOperations.currentUser?.name, 'Demo');
    });

    test('should fail login with invalid credentials', () async {
      final result = await AuthOperations.login('wrong@email.com', 'wrongpass');
      
      expect(result, false);
      expect(AuthOperations.isLoggedIn, false);
      expect(AuthOperations.currentUser, null);
    });

    test('should fail login with wrong password', () async {
      final result = await AuthOperations.login('demo@todo.com', 'wrongpass');
      
      expect(result, false);
      expect(AuthOperations.isLoggedIn, false);
      expect(AuthOperations.currentUser, null);
    });

    test('should logout successfully', () async {
      // First login
      await AuthOperations.login('demo@todo.com', 'demo123');
      expect(AuthOperations.isLoggedIn, true);
      
      // Then logout
      AuthOperations.logout();
      expect(AuthOperations.isLoggedIn, false);
      expect(AuthOperations.currentUser, null);
    });

    test('should validate email format correctly', () {
      expect(AuthOperations.isValidEmail('test@example.com'), true);
      expect(AuthOperations.isValidEmail('user.name@domain.co.uk'), true);
      expect(AuthOperations.isValidEmail('invalid-email'), false);
      expect(AuthOperations.isValidEmail('missing@'), false);
      expect(AuthOperations.isValidEmail('@missing.com'), false);
    });

    test('should return demo credentials', () {
      final credentials = AuthOperations.getDemoCredentials();
      
      expect(credentials.isNotEmpty, true);
      expect(credentials.first.containsKey('email'), true);
      expect(credentials.first.containsKey('password'), true);
    });

    test('should extract name from email correctly', () async {
      await AuthOperations.login('admin@todo.com', 'admin123');
      expect(AuthOperations.currentUser?.name, 'Admin');
    });

    test('should reset todo data on logout', () async {
      // Login first
      await AuthOperations.login('demo@todo.com', 'demo123');

      // Modify todo data
      todoListNotifier.value = [];
      searchQueryNotifier.value = 'test search';
      selectedPageNotifier.value = 1;

      // Logout
      AuthOperations.logout();

      // Check that data is reset
      expect(todoListNotifier.value.length, 3); // Should have default todos
      expect(searchQueryNotifier.value, '');
      expect(selectedPageNotifier.value, 0);
    });

    test('should register new user successfully', () async {
      final result = await AuthOperations.register('John Doe', 'john@example.com', 'password123');

      expect(result['success'], true);
      expect(AuthOperations.isLoggedIn, true);
      expect(AuthOperations.currentUser?.name, 'John Doe');
      expect(AuthOperations.currentUser?.email, 'john@example.com');
    });

    test('should fail registration with existing email', () async {
      // First registration
      await AuthOperations.register('John Doe', 'john@example.com', 'password123');
      AuthOperations.logout();

      // Try to register with same email
      final result = await AuthOperations.register('Jane Doe', 'john@example.com', 'password456');

      expect(result['success'], false);
      expect(result['message'], contains('already exists'));
    });

    test('should fail registration with invalid data', () async {
      // Test short name
      var result = await AuthOperations.register('J', 'john@example.com', 'password123');
      expect(result['success'], false);

      // Test invalid email
      result = await AuthOperations.register('John Doe', 'invalid-email', 'password123');
      expect(result['success'], false);

      // Test short password
      result = await AuthOperations.register('John Doe', 'john@example.com', '123');
      expect(result['success'], false);
    });

    test('should validate password strength correctly', () {
      var validation = AuthOperations.validatePassword('123');
      expect(validation['isValid'], false);
      expect(validation['strength'], 'Weak');

      validation = AuthOperations.validatePassword('password');
      expect(validation['isValid'], true);
      expect(validation['strength'], 'Fair');

      validation = AuthOperations.validatePassword('Password123');
      expect(validation['isValid'], true);
      expect(validation['strength'], 'Strong');
    });

    test('should check email registration status', () {
      expect(AuthOperations.isEmailRegistered('demo@todo.com'), true); // Demo user
      expect(AuthOperations.isEmailRegistered('nonexistent@example.com'), false);
    });

    test('should login with registered user', () async {
      // Register a user
      await AuthOperations.register('Test User', 'testuser@example.com', 'testpass123');
      AuthOperations.logout();

      // Login with registered credentials
      final result = await AuthOperations.login('testuser@example.com', 'testpass123');

      expect(result, true);
      expect(AuthOperations.currentUser?.name, 'Test User');
      expect(AuthOperations.currentUser?.email, 'testuser@example.com');
    });
  });
}
