import 'package:flutter/material.dart';
import 'package:shop_app/widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  static const String ROUTENAME = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
      ),
      body: ProductsGrid(),
    );
  }
}


