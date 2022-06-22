import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';



class BottomBar extends StatefulWidget {
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex = 1;
  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 30.0,),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded,size: 30.0,),label: ""),
        ],
        selectedItemColor: shadePurple,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
  }
}
