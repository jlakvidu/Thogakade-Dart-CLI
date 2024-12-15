import '../model/report.dart';

class ReportService {
  Report generateDailyReport(DateTime date, List<Map<String, dynamic>> orders) {
    double totalSales = orders.fold(0.0, (sum, order) => sum + order['totalAmount']);
    int totalOrders = orders.length;

    return Report(
      date: date,
      totalSales: totalSales,
      totalOrders: totalOrders,
    );
  }
}
