import 'dart:convert';

import 'package:flutter/material.dart';


class NewCard extends StatefulWidget {

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {

  

  void change(){
    print("denemeeee");
  }

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: (){change();},
      behavior: HitTestBehavior.translucent,
      child: Container(
            decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text('ADD NEW CARD',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 50.0),
            ),
          ),
        ),
      
    );
  }
}