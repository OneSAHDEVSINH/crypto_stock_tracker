class Crypto {
  final String name;
  final String symbol;
  final double currentPrice;
  final double marketCap;
  final double changePercentage;
  final String imageUrl;

  Crypto({
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.marketCap,
    required this.changePercentage,
    required this.imageUrl,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'],
      symbol: json['symbol'],
      currentPrice: json['current_price'].toDouble(),
      marketCap: json['market_cap'].toDouble(),
      changePercentage: json['price_change_percentage_24h'].toDouble(),
      imageUrl: json['image'],
    );
  }
}
