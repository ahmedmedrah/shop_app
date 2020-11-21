import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String ROUTENAME = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders!'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error Occured'),
            );
          } else {
            return Consumer<OrdersProvider>(builder: (ctx, ordersData, child) {
              return ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
              );
            });
          }
        },
      ),
    );
  }
}
