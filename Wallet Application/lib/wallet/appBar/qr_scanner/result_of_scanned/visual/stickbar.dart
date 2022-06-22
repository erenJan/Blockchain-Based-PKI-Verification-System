import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
class StickBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        width: 100,
        height: 6,
      ),
    ),
  );
  }
}