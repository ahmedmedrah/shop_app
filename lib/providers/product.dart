import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductModel with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  ProductModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String authToken, String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-app-e4901.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
      print(e.toString());
    }
  }
}
