import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String ROUTENAME = '/product_details';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              height: 300,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$ ${product.price}',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              product.description,
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ]),
      ),
    );
  }
}
