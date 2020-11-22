import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: product.id,
            child: FadeInImage(fadeInDuration: Duration(milliseconds: 200),
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.contain,
            ),
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailsScreen.ROUTENAME, arguments: product.id),
        ),
        header: Container(
          child: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          color: Colors.black54,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            '\$${product.price.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
          ),
          leading: Consumer<ProductModel>(
            builder: (ctx, product, child) => IconButton(
              icon: product.isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                product.toggleFavorite(authData.token,authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added Item to cart'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
