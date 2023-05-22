// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Badget extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;
   Badget({
    
    required this.child,
    required this.value,
    this.color,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned( right: 8,top: 8,child: Container(
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color!=null?color:Colors.green
          ),
          constraints: BoxConstraints(minHeight: 16,minWidth: 16),
          child: Text(value,textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),
        ))
      ],
    );
  }
}
