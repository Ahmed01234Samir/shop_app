// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quntity;

  final String title;
  const CartItem(
    this.id,
    this.productId,
    this.price,
    this.quntity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text("Are You Sure?"),
                    content: Text('Do you want to remove item from the cart?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No!')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes!'))
                    ],
                  ));
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context,listen: false).removeItem(productId);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                  child: Padding(
                child: FittedBox(child: Text('\$$price')),
                padding: EdgeInsets.all(5),
              )),
              title: Text(title),
              subtitle: Text('Total\$${(price * quntity)}'),
              trailing: Text('$quntity x'),
            ),
          ),
        ));
  }
}
