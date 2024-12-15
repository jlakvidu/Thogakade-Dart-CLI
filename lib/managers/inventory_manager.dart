import '../model/order.dart';
import '../model/vegetable.dart';
import '../repositories/inventory_repository.dart';

class InventoryManager {
  final InventoryRepository repository;

  InventoryManager(this.repository);

  Future<List<Vegetable>> loadInventoryFromFile() async {
    return await repository.loadInventoryFromFile();
  }

  Future<List<Order>> loadOrdersFromFile() async {
    return await repository.loadOrdersFromFile();
  }

  Future<void> saveInventoryToFile(List<Vegetable> inventory) async {
    await repository.saveInventoryToFile(inventory);
  }

  Future<void> saveOrderHistory(List<Order> orders) async {
    await repository.saveOrderHistory(orders);
  }
}
