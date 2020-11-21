import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
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
                      '\$${shoppingCart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(shoppingCart: shoppingCart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.shoppingCart,
  }) : super(key: key);

  final Cart shoppingCart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.shoppingCart.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrdersProvider>(context, listen: false).addOrder(
                widget.shoppingCart.items.values.toList(),
                widget.shoppingCart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.shoppingCart.clearCart();
            },
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Text('Order Now!!'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
