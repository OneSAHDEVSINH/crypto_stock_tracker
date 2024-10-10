import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String email = '';
  String password = '';
  bool isLogin = true;
  String errorMessage = '';  // To store error messages

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(isLogin ? 'Login' : 'Register'),
              onPressed: () async {
                String? error;
                if (isLogin) {
                  // Perform login
                  error = await authService.login(email, password);
                } else {
                  // Perform registration
                  error = await authService.register(email, password);
                }

                if (error == null) {
                  // No error, navigate to home screen
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                } else {
                  // Display the error message
                  setState(() {
                    errorMessage = error!;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
            ),
            TextButton(
              child: Text(isLogin ? 'Create an account' : 'Already have an account? Login'),
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                  errorMessage = '';  // Clear error message when switching between login/register
                });
              },
            ),
            // Display error message if any
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
