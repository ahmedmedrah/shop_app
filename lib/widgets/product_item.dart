import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_detal_screen.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;

  ProductItem(this.productModel);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductDetailsScreen(productModel.title),
            ),
          ),
        ),
        header: Container(
          child: Text(
            productModel.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black45,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            productModel.price.toString(),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
