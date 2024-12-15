import '../model/vegetable.dart';

class Validators {
  static bool validateVegetable(Vegetable vegetable) {
    if (vegetable.name.isEmpty || vegetable.pricePerKg <= 0 || vegetable.availableQuantity < 0) {
      return false;
    }
    if (vegetable.expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }
}
