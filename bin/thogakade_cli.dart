import 'dart:io';
import '../lib/managers/thoga_kade_manager.dart';
import '../lib/managers/inventory_manager.dart';
import '../lib/repositories/inventory_repository.dart';
import '../lib/cli/command_handler.dart';

Future<void> main() async {
  final repository = InventoryRepository('inventory.json');
  final inventoryManager = InventoryManager(repository);
  final manager = ThogaKadeManager(inventoryManager);

  await manager.loadInventory();
  await manager.loadOrders();

  final commandHandler = CommandHandler(manager);

  while (true) {
    commandHandler.showMenu();
    stdout.write('Enter your choice:');
    int? choice;

    try {
      choice = int.parse(stdin.readLineSync()!);
    } catch (e) {
      stdout.write('Invalid input. Please enter a number.\n');
      continue;
    }

    commandHandler.handleCommand(choice);

    await manager.saveInventory();
    await manager.saveOrders();
  }
}
