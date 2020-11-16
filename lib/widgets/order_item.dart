import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final OrderItemModel order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${DateFormat.yMMMEd().format(widget.order.time)}'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20 + 30.0, 140),
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.order.products[i].title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${widget.order.products[i].price}\tx\t${widget.order.products[i].quantity}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
            )
        ],
      ),
    );
  }
}
