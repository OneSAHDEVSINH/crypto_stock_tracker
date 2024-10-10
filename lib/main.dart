import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'package:flutter/foundation.dart';  // For platform detection

// Add the Firebase configuration for web
const firebaseConfigWeb = FirebaseOptions(
    apiKey: "AIzaSyBWFR56NU59KM2lvNc00pMF5a8kbXKfIDE",
    authDomain: "cryptostocktracker.firebaseapp.com",
    projectId: "cryptostocktracker",
    storageBucket: "cryptostocktracker.appspot.com",
    messagingSenderId: "311969425961",
    appId: "1:311969425961:web:860a2c2f746a5e28330a38"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use FirebaseOptions for web, otherwise default initialization
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseConfigWeb);
  } else {
    await Firebase.initializeApp();  // For Android/iOS
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),  // Provide AuthService for state management
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto & Stock Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FirebaseInitializer(),  // Show the authentication screen by default
      ),
    );
  }
}

class FirebaseInitializer extends StatefulWidget {
  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  // Initialize Firebase asynchronously and handle errors
  void initializeFirebase() async {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(options: firebaseConfigWeb);  // Initialize for web
      } else {
        await Firebase.initializeApp();  // Initialize for Android/iOS
      }
      setState(() {
        _initialized = true;  // Set initialized to true when Firebase is done
      });
    } catch (e) {
      setState(() {
        _error = true;  // Set error flag if initialization fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If there's an error, show an error message
    if (_error) {
      return Scaffold(
        body: Center(child: Text('Error initializing Firebase')),
      );
    }

    // If Firebase is not initialized yet, show a loading spinner
    if (!_initialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),  // Spinner while loading
      );
    }

    // If Firebase is initialized, navigate to the main app (AuthScreen or HomeScreen)
    return AuthScreen();  // Replace with your main screen or HomeScreen after login
  }
}