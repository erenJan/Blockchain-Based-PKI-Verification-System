import 'package:flutter/material.dart';

class WrongScanned extends StatefulWidget {
  @override
  _WrongScannedState createState() => _WrongScannedState();
}

class _WrongScannedState extends State<WrongScanned> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Icon(Icons.new_releases_rounded,color: Colors.white,),
          ),
        ),
      ],
    );
  }
}