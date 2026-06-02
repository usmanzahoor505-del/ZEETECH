import 'package:flutter/foundation.dart';

class CartItem {
  final String serviceId; // e.g. 'ac', 'cctv'
  final String categoryName; // e.g. 'AC Services'
  final String name; // e.g. 'AC Installation'
  final int price; // e.g. 3200
  int quantity;

  CartItem({
    required this.serviceId,
    required this.categoryName,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'categoryName': categoryName,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal();

  final List<CartItem> _items = [];
  final ValueNotifier<List<CartItem>> cartNotifier = ValueNotifier<List<CartItem>>([]);

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold<int>(0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(String serviceId, String categoryName, String name, int price) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId && item.name == name);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(
        serviceId: serviceId,
        categoryName: categoryName,
        name: name,
        price: price,
        quantity: 1,
      ));
    }
    _notify();
  }

  void removeFromCart(String serviceId, String name) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId && item.name == name);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
    }
    _notify();
  }

  void updateQuantity(String serviceId, String name, int quantity) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId && item.name == name);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _notify();
    }
  }

  void clearCart() {
    _items.clear();
    _notify();
  }

  int getItemQuantity(String serviceId, String name) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId && item.name == name);
    return index != -1 ? _items[index].quantity : 0;
  }

  bool isItemInCart(String serviceId, String name) {
    return _items.any((item) => item.serviceId == serviceId && item.name == name);
  }

  void _notify() {
    cartNotifier.value = List.from(_items);
  }
}
