import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String ROUTENAME = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${shoppingCart.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('Order Now!!'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingCart.items.length,
              itemBuilder: (ctx, i) {
                return CartItem(
                  id: shoppingCart.items.values.toList()[i].id,
                  productId: shoppingCart.items.keys.toList()[i],
                  title: shoppingCart.items.values.toList()[i].title,
                  quantity: shoppingCart.items.values.toList()[i].quantity,
                  price: shoppingCart.items.values.toList()[i].price,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
