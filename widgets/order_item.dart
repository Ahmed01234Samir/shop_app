// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;
  const OrderItem(
    this.order,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
        children: order.products
            .map((prod) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prod.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${prod.quntity}x \$${prod.price}',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
