import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(productId),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.all(4),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(7),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: ListTile(
            leading: Container(
              height: 35,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FittedBox(
                child: Text(
                  '\$ ${price * quantity}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${quantity * price}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
