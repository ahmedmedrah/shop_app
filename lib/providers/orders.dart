import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime time;

  OrderModel({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.time,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final authToken;
  final userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    final url =
        'https://shop-app-e4901.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'datetime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderModel(
          id: json.decode(response.body)['name'],
          products: cartProducts,
          amount: total,
          time: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> fetchOrders() async {
    final url =
        'https://shop-app-e4901.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final List<OrderModel> loadedOrders = [];
      extractedData.forEach((ordId, ordData) {
        loadedOrders.add(OrderModel(
            id: ordId,
            products: (ordData['products'] as List<dynamic>)
                .map((e) => CartItemModel(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']))
                .toList(),
            amount: ordData['amount'],
            time: DateTime.parse(ordData['datetime'])));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
