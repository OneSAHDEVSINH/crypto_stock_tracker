import 'package:flutter/material.dart';
import '../models/crypto_model.dart';
import '../services/api_service.dart';

class CryptoScreen extends StatefulWidget {
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<Crypto> cryptos = [];
  bool _loading = true;  // Track the loading state
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchCryptos();
  }

  // Fetch cryptos and handle loading state
  fetchCryptos() async {
    try {
      cryptos = await apiService.fetchCryptos();
      setState(() {
        _loading = false;  // Stop loading when data is fetched
      });
    } catch (e) {
      setState(() {
        _loading = false;  // Stop loading even if an error occurs
        // Show an error message or handle the error as needed
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch cryptocurrency data')),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto Tracker')),
      body: _loading
          ? Center(child: CircularProgressIndicator())  // Show spinner while loading
          : ListView.builder(
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          final crypto = cryptos[index];
          return ListTile(
            leading: Image.network(crypto.imageUrl, width: 50),
            title: Text(crypto.name),
            subtitle: Text('Price: \$${crypto.currentPrice}'),
          );
        },
      ),
    );
  }
}