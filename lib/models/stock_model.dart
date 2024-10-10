class Stock {
  final String symbol;
  final double price;
  final double changePercentage;
  final String lastUpdated;

  Stock({
    required this.symbol,
    required this.price,
    required this.changePercentage,
    required this.lastUpdated,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      price: double.parse(json['price']),
      changePercentage: double.parse(json['changePercentage']),
      lastUpdated: json['lastUpdated'],
    );
  }
}
