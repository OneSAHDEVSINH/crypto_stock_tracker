import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'crypto_screen.dart';
import 'stock_screen.dart';
import 'news_screen.dart';
import 'auth_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // If the user is not logged in, show the AuthScreen
    if (authService.user == null) {
      return AuthScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto & Stock Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Crypto Tracker'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CryptoScreen()));
              },
            ),
            ElevatedButton(
              child: Text('Stock Tracker'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StockScreen()));
              },
            ),
            ElevatedButton(
              child: Text('Market News'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
