import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../services/api_service.dart';
//import 'package:flutter/widgets.dart';
import 'package:fl_chart/fl_chart.dart';  // For charts
import 'dart:async';  // Import for Timer

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  Stock? stock;
  List<Stock> stocks = [];
  List<double> stockHistory = [];
  bool _loading = true;  // Track the loading state
  final ApiService apiService = ApiService();
  final List<String> stockSymbols = ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN', 'META', 'NFLX', 'NVDA', 'INTC', 'DIS'];  // Add as many symbols as you want
  Timer? _timer;  // Timer to refresh stock data periodically
  final Map<String, String> stockLogos = {
    'AAPL': 'https://logo.clearbit.com/apple.com',
    'GOOGL': 'https://logo.clearbit.com/google.com',
    'MSFT': 'https://logo.clearbit.com/microsoft.com',
    'TSLA': 'https://logo.clearbit.com/tesla.com',
    'AMZN': 'https://logo.clearbit.com/amazon.com',
    'NFLX': 'https://logo.clearbit.com/netflix.com',
  };

  //final logoUrl = stockLogos[stock.symbol] ?? 'https://example.com/default_logo.png';  // Fallback to default logo

  @override
  void initState() {
    super.initState();
    fetchStock();
    fetchMultipleStocks();
    startAutoRefresh();  // Start automatic refresh for real-time updates
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Start a timer to refresh stock data every minute
  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchMultipleStocks();  // Refresh stock data
    });
  }

  // Fetch stock data and handle loading state
  fetchStock() async {
    try {
      stock = await apiService.fetchStock('AAPL');  // Fetch Apple stock as an example
      setState(() {
        _loading = false;  // Stop loading when data is fetched
      });
    } catch (e) {
      setState(() {
        _loading = false;  // Stop loading even if an error occurs
        // Handle error accordingly (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch stock data')),
        );
      });
    }
  }

  // Fetch data for multiple stocks and update state
  fetchMultipleStocks() async {
    setState(() {
      _loading = true;
    });
    try {
      stocks = await Future.wait(stockSymbols.map((symbol) => apiService.fetchStock(symbol)).toList());
      stockHistory = await apiService.fetchStockHistory(stockSymbols[0]);  // Fetch history for the first stock
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching stock data')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Tracker')),
      body: _loading
          ? Center(child: CircularProgressIndicator())  // Show spinner while loading
          : stock == null
          ? Center(child: Text('No stock data available'))  // Handle no data case
          : ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return StockCard(stock: stock);  // Display StockCard with logos
          // return ListTile(
          //   title: Text(stock.symbol),
          //   subtitle: Text('Price: \$${stock.price}, Change: ${stock.changePercentage}%'),
          //   trailing: Text('Last Updated: ${stock.lastUpdated}'),
          // );
          return Column(
            children: [
              StockCard(stock: stock),  // Custom widget to show stock card
              if (index == 0) // Display chart only for the first stock
                StockChart(stockHistory: stockHistory),
            ],
          );
        },
      ),
      //     : ListTile(
      //   title: Text(stock!.symbol),
      //   subtitle: Text('Price: \$${stock!.price}'),
      // ),
    );
  }
}

// Custom widget for displaying stock card with price, percentage, and arrows
class StockCard extends StatelessWidget {
  final Stock stock;
  const StockCard({required this.stock});

  @override
  Widget build(BuildContext context) {
    bool isPositiveChange = stock.changePercentage > 0;

    // Example logo URL (you can adjust the URL based on the company's domain)
    final logoUrl = "https://logo.clearbit.com/${stock.symbol.toLowerCase()}.com";

    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: logoUrl,  // Load the logo from the logo service
          width: 50,  // Set the logo width
          placeholder: (context, url) => CircularProgressIndicator(),  // Loading placeholder
          errorWidget: (context, url, error) => Icon(Icons.error),  // Fallback icon if loading fails
        ),
        title: Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text('Last Updated: ${stock.lastUpdated}', style: TextStyle(fontSize: 12)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isPositiveChange ? Colors.green : Colors.red,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositiveChange ? Colors.green : Colors.red,
                ),
                Text(
                  '${stock.changePercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositiveChange ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Custom widget for displaying stock chart
class StockChart extends StatelessWidget {
  final List<double> stockHistory;
  const StockChart({required this.stockHistory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: stockHistory.length.toDouble(),
          minY: stockHistory.reduce((a, b) => a < b ? a : b),
          maxY: stockHistory.reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: stockHistory.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],  // Define a gradient with two or more colors
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}