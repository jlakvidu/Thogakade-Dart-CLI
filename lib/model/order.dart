class Order {
  final String id;
  final Map<String, double> items;
  final double totalAmount;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'orderID': id,
        'items': items,
        'totalAmount': totalAmount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['orderID'],
        items: Map<String, double>.from(json['items']),
        totalAmount: json['totalAmount'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
