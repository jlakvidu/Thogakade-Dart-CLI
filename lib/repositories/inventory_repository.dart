import '../model/order.dart';
import '../services/file_service.dart';
import '../model/vegetable.dart';

class InventoryRepository {
  final FileService fileService;

  InventoryRepository(String filePath) : fileService = FileService(filePath);

  Future<void> saveInventoryToFile(List<Vegetable> inventory) async {
    final data = await fileService.readFromFile() ?? {};

    data["inventory"] = inventory.map((v) => v.toJson()).toList();

    await fileService.writeToFile(data);
  }

  Future<void> saveOrderHistory(List<Order> orders) async {
    final data = await fileService.readFromFile() ?? {};

    data["orders"] = orders.map((v) => v.toJson()).toList();

    await fileService.writeToFile(data);
  }

  Future<List<Vegetable>> loadInventoryFromFile() async {
    final data = await fileService.readFromFile();
    if (data != null && data["inventory"] != null) {
      return (data["inventory"] as List<dynamic>)
          .map((item) => Vegetable.fromJson(item))
          .toList();
    }
    return [];
  }

  Future<List<Order>> loadOrdersFromFile() async {
    final data = await fileService.readFromFile();
    if (data != null && data["orders"] != null) {
      return (data["orders"] as List<dynamic>)
          .map((item) => Order.fromJson(item))
          .toList();
    }
    return [];
  }

  Future<void> backupInventory(String backupPath) async {
    await fileService.backupFile(backupPath);
  }
}
