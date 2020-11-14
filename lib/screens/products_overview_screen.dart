import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum menuOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const String ROUTENAME = '/';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cartData, child) =>
                Badge(child: child, value: cartData.getItemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.ROUTENAME);
              },
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: menuOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: menuOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (menuOptions selected) {
              setState(() {
                if (selected == menuOptions.All) {
                  _showFavoriteOnly = false;
                } else if (selected == menuOptions.Favorites) {
                  _showFavoriteOnly = true;
                }
              });
            },
          ),
        ],
      ),
      body: ProductsGrid(_showFavoriteOnly),
    );
  }
}
