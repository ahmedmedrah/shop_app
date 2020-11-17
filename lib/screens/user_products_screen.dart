import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String ROUTENAME = '/user_products_screen';

  @override
  Widget build(BuildContext context) {
    final prodcuts = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: prodcuts.length,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                UserProductItem(prodcuts[i].title, prodcuts[i].imageUrl),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
