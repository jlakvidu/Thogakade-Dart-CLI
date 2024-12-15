import '../model/order.dart';
import '../model/vegetable.dart';
import 'inventory_manager.dart';

abstract class ThogaKadeState {}

class LoadingState extends ThogaKadeState {}

class LoadedState extends ThogaKadeState {}

class ErrorState extends ThogaKadeState {
  final String message;
  ErrorState(this.message);
}

class ThogaKadeManager {
  List<Vegetable> inventory = [];
  List<Order> orders = [];
  ThogaKadeState state = LoadingState();
  final InventoryManager inventoryManager;

  ThogaKadeManager(this.inventoryManager);

  Future<void> loadInventory() async {
    try {
      inventory = await inventoryManager.loadInventoryFromFile();
      state = LoadedState();
    } catch (e) {
      state = ErrorState('Failed to load inventory: ${e.toString()}');
    }
  }

  Future<void> loadOrders() async {
    try {
      orders = await inventoryManager.loadOrdersFromFile();
      state = LoadedState();
    } catch (e) {
      state = ErrorState('Failed to load orders: ${e.toString()}');
    }
  }

  Future<void> saveInventory() async {
    try {
      await inventoryManager.saveInventoryToFile(inventory);
      state = LoadedState();
    } catch (e) {
      state = ErrorState('Failed to save inventory: ${e.toString()}');
    }
  }

  Future<void> saveOrders() async {
    try {
      await inventoryManager.saveOrderHistory(orders);
      state = LoadedState();
    } catch (e) {
      state = ErrorState('Failed to save inventory: ${e.toString()}');
    }
  }

  void addVegetable(Vegetable vegetable) {
    inventory.add(vegetable);
    state = LoadedState();
  }

  void removeVegetable(String id) {
    inventory.removeWhere((vegetable) => vegetable.id == id);
    state = LoadedState();
  }

  void updateStock(String id, double quantity) {
    final vegetable = inventory.firstWhere((v) => v.id == id);
    vegetable.availableQuantity += quantity;
    state = LoadedState();
  }

  dynamic getById(String id) {
    return inventory.firstWhere(
      (veg) => veg.id == id,
      orElse: () => Vegetable(
        id: 'unknown',
        name: 'Unknown Vegetable',
        pricePerKg: 0.0,
        availableQuantity: 0,
        category: 'unknown',
        expiryDate: DateTime.now(),
      ),
    );
  }

  void processOrder(Order order) {
    orders.add(order);

    order.items.forEach((id, quantity) {
      Vegetable vegetable = getById(id);

      if (vegetable.id != 'unknown') {
        vegetable.availableQuantity -= quantity;
        state = LoadedState();
      } else {
        state = ErrorState('Vegetable with ID $id not found');
      }
    });
    state = LoadedState();
  }
}
