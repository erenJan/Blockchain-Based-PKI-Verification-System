import 'package:beChain/wallet/appBar/qr_scanner/pop_up_context.dart';
import 'package:beChain/wallet/appBar/qr_scanner/scanner_camera.dart';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'qr_scanner/pop_up.dart';
import 'package:beChain/wallet/logIn/login_pop_up.dart';
import 'package:beChain/wallet/sideMenu/side_bar.dart';


class WalletAppBar extends StatelessWidget with PreferredSizeWidget {
  
  const WalletAppBar({Key key,@required this.authKey}) : super(key: key);
  final authKey;
  void callBack(){
    
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: authKey ? Icon(Icons.menu) : Icon(Icons.person),
            onPressed: () => Scaffold.of(context).openDrawer(), 
          )
        ),
        title: Text("Wallet"),
        actions: <Widget>[
          IconButton(
            onPressed: (){QrPopUp(context);}, 
            icon: Icon(Icons.qr_code_scanner_rounded,)
          )
        ],
        backgroundColor: background,
        bottom: PreferredSize(
          child: Container(
            color: Color(0x322841),
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}