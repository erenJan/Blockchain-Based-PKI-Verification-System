import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';

import 'package:http/http.dart';
import 'generate.dart';

void WalletGeneration(context,walletName){
  print(walletName);
  showModalBottomSheet(
    isScrollControlled:true,
    isDismissible: true,
    enableDrag: true,
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (BuildContext context){
      return NewWallet(walletName);
}
  );
}

class NewWallet extends StatefulWidget {
  final walletName;
  NewWallet(this.walletName, {Key key}) : super(key: key);

  @override
  State<NewWallet> createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> {
  
  var private_key;
  var public_key;
  @override


  void getHttpRq() async{
        var priv;
        var public;
        var url = Uri.parse('http://10.2.176.42:3000/api/create-new-wallet');
        var response = await get(
          url
          ).then((response){
          print(response);
          var result = json.decode(response.body);
          print(result);
          priv = result["private_address"];
          public = result["public_address"];
          
        });
        setState(() {
          private_key = priv;
          print(priv);
          public_key = public;
          print(public);
        });
    }
  @override
  void initState() {
    
    getHttpRq();

    super.initState();
    
  }

  Widget build(BuildContext context) {
    print(widget.walletName);
    return  DraggableScrollableSheet(
        builder: (context, scrollController) {
        return Container(
          height: 900,
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
              color: background,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40),
                topRight: const Radius.circular(40)
              ),
              boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 1.5,
                  ),
                ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(widget.walletName??"",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Private Address",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                        Text(private_key??"",style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Public Address",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                        Text(public_key??"",style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text("Do not forget to take screen shot",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                                  )
                                ),
                                onTap:(){
                                  generateWallet(context,widget.walletName,private_key,public_key);
                                },
                              ),
                ],
              ),
            ),
          )
        
      );
    }
  );
  }
  
}