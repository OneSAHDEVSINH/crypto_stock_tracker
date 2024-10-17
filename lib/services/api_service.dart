import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';
import '../models/stock_model.dart';

class ApiService {
  final String cryptoUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';
  final String stockApiKey = 'YOUR_API';
  final String financeApiKey = 'YOUR_API';

  // Fetch cryptocurrency data
  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse(cryptoUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Crypto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cryptocurrency data');
    }
  }

  // Fetch stock market data
  Future<Stock> fetchStock(String symbol) async {
    final stockUrl = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$stockApiKey';
    final response = await http.get(Uri.parse(stockUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Global Quote'];
      return Stock(
        symbol: data['01. symbol'],
        price: double.parse(data['05. price']),
        changePercentage: double.parse(data['10. change percent'].replaceAll('%', '')),
        lastUpdated: data['07. latest trading day'],
      );
    } else {
      throw Exception('Failed to load stock data for $symbol');
    }
  }

  // Fetch stock data for multiple stock symbols
  Future<List<Stock>> fetchMultipleStocks(List<String> symbols) async {
    List<Stock> stocks = [];
    for (String symbol in symbols) {
      try {
        Stock stock = await fetchStock(symbol);
        stocks.add(stock);
      } catch (e) {
        // Handle any errors for individual stocks, you could skip or log the error
        print('Error fetching data for $symbol: $e');
      }
    }
    return stocks;
  }

  // Fetch historical stock data for the chart
  Future<List<double>> fetchStockHistory(String symbol) async {
    final stockHistoryUrl = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$stockApiKey';
    final response = await http.get(Uri.parse(stockHistoryUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Time Series (5min)'];
      List<double> prices = data.values.map<double>((item) => double.parse(item['4. close'])).toList();
      return prices.reversed.toList();  // Reverse the list to show the latest prices first
    } else {
      throw Exception('Failed to load stock history for $symbol');
    }
  }



  // Fetch financial news
  Future<List<dynamic>> fetchNews() async {
    final newsUrl = 'https://newsapi.org/v2/everything?q=finance&apiKey=$financeApiKey';
    final response = await http.get(Uri.parse(newsUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}

