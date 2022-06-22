
import 'dart:convert';
import 'package:beChain/wallet/storage/modals/auth.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:country_list_pick/country_list_pick.dart';

import 'package:beChain/wallet/storage/modals/auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'package:beChain/wallet/wallet_page.dart';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:beChain/wallet/storage/modals/auth.dart';

/*
void getHttpRq() async{
  var url = Uri.parse('https://c499-178-233-20-209.ngrok.io/users');
  var response = await http.get(url);
  print(response.body);
}
*/

  
getHttpRq(context,username,password) async{
  var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/auth');
  var response = await http.post(
    url,
    headers: {"Content-Type":"application/json"},
    encoding: Encoding.getByName("utf-8"),
    body:jsonEncode({'username': '$username' ,'password':'$password'})

  ).then((response){
    
    if(response.statusCode == 200){
      success();
      var newWallet = Auth(
            id:response.body,
        );
      print("ok1");
      Future<void> insertWallet(Auth wallet) async{
        final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'),version: 1,);
        final db = await database;
        await db.insert(
          'auth',
          wallet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print("ok2");
      insertWallet(newWallet);
      Navigator.pop(context);
    }else{
      failed();
    }
      
  });
}

getHttpRqUp(context,username,password,firstName,lastName,countryCode) async{
  var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/subs');
  var response = await http.post(
    url,
    headers: {"Content-Type":"application/json"},
    encoding: Encoding.getByName("utf-8"),
    body:jsonEncode({'username': '$username' ,'password':'$password'})

  ).then((response) async {
    
    if(response.statusCode == 200){
      success();
      var newWallet = Auth(
            id:response.body,
        );
      print("ok1");
      String id = response.body;
      Future<void> insertWallet(Auth wallet) async{
        final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'),version: 1,);
        final db = await database;
        await db.insert(
          'auth',
          wallet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print("ok2");
      insertWallet(newWallet);
      var url2 = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/data/subs/$id');
      var response2 = await http.post(
        url2,
        headers: {"Content-Type":"application/json"},
        encoding: Encoding.getByName("utf-8"),
        body:jsonEncode({'firstname': '$firstName' ,'lastname':'$lastName','country':'$countryCode','phone':'5319201762'})

      ).then((response2){
        if(response.statusCode == 200){
          Navigator.pop(context);
        }else{
           Navigator.pop(context);
        }
       
      });
      
    }else{
      failed();
    }
      
  });
}


success(){
  showSimpleNotification(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Success!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
        Text("Welcome back !",style: TextStyle(color: Colors.white,fontSize: 16),)
      ],
    ),
    background: Colors.green
  );
}
failed(){
  showSimpleNotification(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Failed!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
        Text("Try to make it right sir!",style: TextStyle(color: Colors.white,fontSize: 16),)
      ],
    ),
    background: Colors.red
  );
}



class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  List<Widget> pages;
  int currentview = 0;

  void initState(){
    pages = [
      welcome(),
      logIn(),
      signUp()
    ];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return pages[currentview];
  }

  List welcomeSteps = ['Secure Payment', 'Keep Anonymity', 'Verification'];

  Widget welcome(){
    
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
      return Container(
        color: Colors.transparent,
        child: Container(
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.all(Radius.circular(40)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom:40.0,left: 30.0,right: 30.0,top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //slider
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 460,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal
                    ),
                    items: welcomeSteps.map((i){
                      String name = i;
                      print(name);
                      return Padding(
                        padding: EdgeInsets.only(top:10),
                        child: Builder(
                          builder: (BuildContext context){
                            switch (name) {
                              case "Secure Payment":
                                return Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Image.asset('assets/securePayments.png'),
                                        Text(i,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24)),
                                        Text("Be aware of your spents",style: TextStyle(fontWeight:FontWeight.w300,color: Colors.white),)
                                      ],
                                    ),
                                  )
                                );
                                break;
                              case "Keep Anonymity":
                                return Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Image.asset('assets/keep_anonymity.png'),
                                        SizedBox(height: 40,),
                                        Text(i,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24)),
                                        Text("Keep your address privately.",style: TextStyle(fontWeight:FontWeight.w300,color: Colors.white),)
                                      ],
                                    ),
                                  )
                                );
                                break;
                              case "Verification":
                                return Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Image.asset('assets/verification.png'),
                                        Text(i,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24)),
                                        Text("Verify your wallet to avoid miss actions.",style: TextStyle(fontWeight:FontWeight.w300,color: Colors.white),)
                                      ],
                                    ),
                                  )
                                );
                                break;
                            }
                            return Container();
                        })
                      );
                    }).toList()
                  ),
                ),
                //buttons
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Center(
                            child: Text("Log In",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                          )
                        ),
                        onTap:(){
                          setState(() {
                            currentview = 1;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Center(
                            child: Text("Sign Up",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                          )
                        ),
                        onTap:(){
                          setState(() {
                            currentview = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  )
              ],
              ),
            )
          )  
        );
      }
    );
  }
  Widget logIn(){
    TextEditingController username= TextEditingController();
    TextEditingController password = TextEditingController();
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
              color: bussiness,
              borderRadius: new BorderRadius.all(Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //welcome text
                  Column(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/verification.png',height: 200,),
                          Text("Welcome back!",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                          Text("Login to your account", style: TextStyle(color: Colors.white,fontSize: 14),),
                        ],
                      ),
                      //texfields
                      Padding(
                        padding: const EdgeInsets.only(right:30.0,left: 30.0,top:50),
                        child: Column(
                          children: [
                            TextField(
                              style: TextStyle(color: Colors.white),
                              controller: username,
                              decoration: InputDecoration(
                                fillColor: sideBar,
                                prefixIcon: Icon(Icons.email_rounded,color: Colors.white,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "E-mail",
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 40,),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: password,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key_rounded,color: Colors.white,),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue,width: 10),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:50.0,right: 50.0,top: 30),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: (){getHttpRq(context,username.text,password.text);},
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.blue
                                      ),
                                      child: Center(
                                        child: Text("Sign In",style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: bussiness2,
                    child: Padding(
                      padding: EdgeInsets.only(top:20),
                      child: Text("Don't have an account? Sign up ",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  } 
  
  Widget signUp(){
    int countryCode;
    TextEditingController username= TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController first_name= TextEditingController();
    TextEditingController last_name = TextEditingController();
    void changeName(cod){
      setState(() {
        countryCode = cod;
      });
    }
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
              color: bussiness,
              borderRadius: new BorderRadius.all(Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //welcome text
                  Column(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/verification.png',height: 200,),
                          Text("Welcome back!",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                          Text("Login to your account", style: TextStyle(color: Colors.white,fontSize: 14),),
                        ],
                      ),
                      //texfields
                      Padding(
                        padding: const EdgeInsets.only(right:30.0,left: 30.0,top:50),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: first_name,
                                    decoration: InputDecoration(
                                      fillColor: sideBar,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                      ),
                                      labelText: "First Name",
                                      labelStyle: TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Flexible(
                                  flex: 5,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: last_name,
                                    decoration: InputDecoration(
                                      fillColor: sideBar,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                      ),
                                      labelText: "Last Name",
                                      labelStyle: TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              controller: username,
                              decoration: InputDecoration(
                                fillColor: sideBar,
                                prefixIcon: Icon(Icons.email_rounded,color: Colors.white,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "E-mail",
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key_rounded,color: Colors.white,),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue,width: 10),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "Password",
                                  
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key_rounded,color: Colors.white,),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue,width: 10),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "Re-Password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffix: CountryListPick(
                      appBar: AppBar(
                        backgroundColor: Colors.blue,
                        title: Text('Choisir un pays'),
                      ),
                      theme: CountryTheme(
                        isShowFlag: true,
                        isShowTitle: true,
                        isShowCode: true,
                        isDownIcon: true,
                        showEnglishName: true,
                      ),
                      // Set default value
                      initialSelection: '+62',
                      // or
                      // initialSelection: 'US'
                      onChanged: (CountryCode code) {
                        print(code.name);
                        print(code.code);
                        print(code.dialCode);
                        print(code.flagUri);
                      },
                      useUiOverlay: true,
                      useSafeArea: false
                      ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue,width: 10),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:50.0,right: 50.0,top: 30),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: (){getHttpRqUp(context,username.text,password.text,first_name.text,last_name.text,countryCode);},
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.blue
                                      ),
                                      child: Center(
                                        child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  } 
}

