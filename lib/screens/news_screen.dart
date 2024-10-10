import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> news = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    news = await apiService.fetchNews();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Market News')),
      body: news.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return ListTile(
            title: Text(article['title']),
            subtitle: Text(article['source']['name']),
          );
        },
      ),
    );
  }
}
