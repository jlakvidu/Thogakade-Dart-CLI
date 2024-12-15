import 'package:thogakade_cli/model/report.dart';
import 'package:thogakade_cli/services/report_service.dart';

import '../managers/thoga_kade_manager.dart';
import 'dart:io';
import '../model/order.dart';
import '../model/vegetable.dart';

class CommandHandler {
  final ThogaKadeManager manager;

  CommandHandler(this.manager);

  void showMenu() {
    print(' +------------------------+');
    print(' |    Thoga Kade Menu     |');
    print(' +------------------------+');
    print(' | 1. View Stock Orders   |');
    print(' +------------------------+');
    print(' | 2. Add Vegetable       |');
    print(' +------------------------+');
    print(' | 3. Remove Vegetable    |');
    print(' +------------------------+');
    print(' | 4. Update Stock        |');
    print(' +------------------------+');
    print(' | 5. Process Order       |');
    print(' +------------------------+');
    print(' | 6. Generate Report     |');
    print(' +------------------------+');
    print(' | 7. Exit                |');
    print(' +------------------------+');
  }

  void handleCommand(int choice) {
    switch (choice) {
      case 1:
        viewInventoryAndOrders();
        break;
      case 2:
        addVegetable();
        break;
      case 3:
        removeVegetable();
        break;
      case 4:
        updateStock();
        break;
      case 5:
        processOrder();
        break;
      case 6:
        generateReport();
        break;
      case 7:
        stdout.write('Exiting...\n');
        exit(0);
      default:
        stdout.write('Invalid choice!\n');
    }
  }

  void clearScreen() {
    stdout.write('\x1B[2J\x1B[H');
  }

  void viewInventoryAndOrders() {
    printInventoryTbl();
    printOrdersTbl();

    print('\nPress Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }

  void printInventoryTbl() {
    clearScreen();

    print(' Inventory');
    print(
        ' +-------------------------------------------------------------------+');
    print(
        ' | Id    | Name          | Available Qty | Price per kg  | Category  |');
    print(
        ' +-------------------------------------------------------------------+');

    if (manager.inventory.isEmpty) {
      print(
          ' | Inventory is empty.                                               |');
      print(
          ' +-------------------------------------------------------------------+');
    } else {
      for (var veg in manager.inventory) {
        String row = ' | ${veg.id.padRight(5)} | '
            '${veg.name.padRight(13)} | '
            '${veg.availableQuantity.toString().padLeft(13)} | '
            '\$${veg.pricePerKg.toStringAsFixed(2).padLeft(12)} | '
            '${veg.category.padRight(9)} |';
        print(row);
        print(
            ' +-------------------------------------------------------------------+');
      }
    }
  }

  void printOrdersTbl() {
    print('\n\n Orders');
    print(
        ' +----------------------------------------------------------------+');
    print(
        ' | Id    | Item Count | Total Amount |       Date and Time        |');
    print(
        ' +----------------------------------------------------------------+');

    if (manager.inventory.isEmpty) {
      print(
          ' | No Orders.                                                     |');
      print(
          ' +----------------------------------------------------------------+');
    } else {
      for (var order in manager.orders) {
        String row = ' | ${order.id.padRight(5)} | '
            '${order.items.length.toString().padRight(10)} | '
            '\$${order.totalAmount.toString().padLeft(11)} | '
            '${order.timestamp.toString().padRight(20)} |';
        print(row);
        print(
            ' +----------------------------------------------------------------+');
      }
    }
  }

  void addVegetable() {
    clearScreen();
    stdout.write('Enter Vegetable Details:\n');

    String id = 'I${(manager.inventory.length + 1).toString().padLeft(3, '0')}';
    print('ID: $id');

    stdout.write('Name: ');
    String name = stdin.readLineSync()!.trim();
    stdout.write('Price per kg: ');
    double pricePerKg = double.parse(stdin.readLineSync()!.trim());
    stdout.write('Available Quantity: ');
    double quantity = double.parse(stdin.readLineSync()!.trim());
    stdout.write('Category (leafy/root/fruit): ');
    String category = stdin.readLineSync()!.trim();
    stdout.write('Expiry Date (YYYY-MM-DD): ');

    DateTime expiryDate;
    try {
      expiryDate = DateTime.parse(stdin.readLineSync()!.trim());
    } catch (e) {
      stdout.write(
          'Invalid date format. Please enter the date in YYYY-MM-DD format.\n');
      return;
    }

    var vegetable = Vegetable(
      id: id,
      name: name,
      pricePerKg: pricePerKg,
      availableQuantity: quantity,
      category: category,
      expiryDate: expiryDate,
    );

    manager.addVegetable(vegetable);
    stdout.write('Vegetable added successfully.\n');
    stdout.write('\nPress Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }

  void removeVegetable() {
    clearScreen();

    printInventoryTbl();

    stdout.write('Enter Vegetable ID to Remove: ');
    String id = stdin.readLineSync()!.trim();
    manager.removeVegetable(id);

    stdout.write('Vegetable removed successfully.\n');
    stdout.write('\nPress Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }

  void updateStock() {
    clearScreen();

    printInventoryTbl();

    stdout.write('Enter Vegetable ID: ');
    String id = stdin.readLineSync()!.trim();

    stdout.write('Enter Quantity to Add: ');
    double quantity = double.parse(stdin.readLineSync()!.trim());
    manager.updateStock(id, quantity);

    stdout.write('Stock updated successfully.\n');
    stdout.write('\nPress Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }

  void processOrder() {
    clearScreen();

    printInventoryTbl();

    String id = 'O${(manager.orders.length + 1).toString().padLeft(3, '0')}';
    print('Order ID: $id');

    Map<String, double> items = {};

    while (true) {
      stdout.write('Enter Vegetable ID (or type "done" to finish): ');
      String id = stdin.readLineSync()!.trim();
      if (id.toLowerCase() == 'done') break;

      Vegetable vegetable = manager.getById(id);

      if (vegetable.id == 'unknown') {
        stdout.write('Invalid Vegetable ID. Please try again.\n');
        continue;
      }

      stdout.write('Enter Quantity for $id: ');
      double quantity;

      try {
        quantity = double.parse(stdin.readLineSync()!.trim());
      } catch (e) {
        stdout.write('Invalid quantity. Please enter a number.\n');
        continue;
      }

      if (quantity <= 0) {
        stdout.write('Quantity must be greater than 0. Please try again.\n');
        continue;
      }

      if (quantity > vegetable.availableQuantity) {
        stdout.write(
            'Insufficient stock for $id. Available: ${vegetable.availableQuantity}kg. Please try again.\n');
        continue;
      }
      items[id] = quantity;
    }

    if (items.isEmpty) {
      stdout.write('No items were added to the order.\n');
      return;
    }

    var order = Order(
      id: id,
      items: items,
      totalAmount: calculateTotalAmount(items),
      timestamp: DateTime.now(),
    );

    manager.processOrder(order);

    print('\nOrder Summary:');
    print('----------------------');
    print('Item Count : ${order.items.length}');
    print('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}');
    print('\nOrder processed successfully.');
    print('Press Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }

  double calculateTotalAmount(Map<String, double> items) {
    double total = 0.0;
    for (var entry in items.entries) {
      Vegetable vegetable = manager.getById(entry.key);
      total += vegetable.pricePerKg * entry.value;
    }
    return total;
  }

  void generateReport() {
    clearScreen();

    stdout.write('Enter the date for the report (YYYY-MM-DD): ');
    String? inputDate = stdin.readLineSync();
    if (inputDate == null || inputDate.isEmpty) {
      stdout.write('Invalid date. Returning to the menu.\n');
      return;
    }

    DateTime reportDate;
    try {
      reportDate = DateTime.parse(inputDate);
    } catch (e) {
      stdout.write('Invalid date format. Please use YYYY-MM-DD.\n');
      return;
    }

    List<Map<String, dynamic>> dailyOrders = manager.orders
        .where((order) =>
            order.timestamp.year == reportDate.year &&
            order.timestamp.month == reportDate.month &&
            order.timestamp.day == reportDate.day)
        .map((order) => order.toJson())
        .toList();

    if (dailyOrders.isEmpty) {
      stdout.write('No orders found for the given date.\n');
      stdout.write('\nPress Enter to return to the menu.');
      stdin.readLineSync();
      clearScreen();
      return;
    }

    ReportService reportService = ReportService();
    Report report = reportService.generateDailyReport(reportDate, dailyOrders);

    print(
        '\n +------------------------------------------------+');
    print(
        ' |    Date    |   Total Sales    |  Total Orders  |');
    print(
        ' +------------------------------------------------+');
    print(
        ' | ${report.date.toIso8601String().split("T")[0].padRight(10)} | \$${report.totalSales.toStringAsFixed(2).padLeft(15)} | ${report.totalOrders.toString().padLeft(14)} |');
    print(
        ' +------------------------------------------------+');

    stdout.write('\nPress Enter to return to the menu.');
    stdin.readLineSync();
    clearScreen();
  }
}
