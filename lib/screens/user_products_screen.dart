import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String ROUTENAME = '/user_products_screen';

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.ROUTENAME);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState != ConnectionState.done
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshData(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, products, _) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: products.items.length,
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: [
                                  UserProductItem(
                                      products.items[i].id,
                                      products.items[i].title,
                                      products.items[i].imageUrl),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.ROUTENAME);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
