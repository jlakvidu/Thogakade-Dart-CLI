class Report {
  final DateTime date;
  final double totalSales;
  final int totalOrders;

  Report({
    required this.date,
    required this.totalSales,
    required this.totalOrders,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalSales': totalSales,
    'totalOrders': totalOrders,
  };

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    date: DateTime.parse(json['date']),
    totalSales: json['totalSales'],
    totalOrders: json['totalOrders'],
  );
}
