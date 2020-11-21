import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<ProductModel> _items = [];
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  // List<ProductModel> _items = [
  //   ProductModel(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   ProductModel(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   ProductModel(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   ProductModel(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   )
  // ];

  List<ProductModel> get items {
    return [..._items];
  }

  List<ProductModel> get favoriteItems {
    return _items.where((e) => e.isFavorite).toList();
  }

  Future<void> fetchProducts(bool filterByUser) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-app-e4901.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
          'https://shop-app-e4901.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body) as Map<String, dynamic>;
      final List<ProductModel> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(ProductModel(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: favData == null ? false : favData[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final url =
        'https://shop-app-e4901.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId':userId,
          }));
      product.id = json.decode(response.body)['name'];
      _items.add(product);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          'https://shop-app-e4901.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            }));
        _items[index] = product;
        notifyListeners();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-e4901.firebaseio.com/products/$id.json?auth=$authToken';
    var deletedProductIndex = _items.indexWhere((element) => element.id == id);
    var deletedProduct = _items[deletedProductIndex];
    _items.removeAt(deletedProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(deletedProductIndex, deletedProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    deletedProduct = null;
    deletedProductIndex = null;
  }

  ProductModel findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
