import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItemModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime time;

  OrderItemModel({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemModel> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItemModel(
        id: DateTime.now().toString(),
        products: cartProducts,
        amount: total,
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
