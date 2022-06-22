import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:beChain/wallet/wallet_page.dart';

import 'package:overlay_support/overlay_support.dart';
import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:beChain/wallet/storage/modals/auth.dart';
class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

class SideMenu extends StatefulWidget {
  SideMenu({Key key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final List<List> privacySteps = [
    ["email","erencanerel@gmail.com","verified"],
    ["phone","+90(531)9201762","verified"],
    ["KYC",null,"unverified"]
    ];

  bool auth = false;

  @override
  Widget build(BuildContext context) {
    return PersonalDashBoard(privacySteps: privacySteps);
  }
}

class PersonalDashBoard extends StatefulWidget {
  const PersonalDashBoard({
    Key key,
    @required this.privacySteps,
  }) : super(key: key);

  final List<List> privacySteps;

  @override
  State<PersonalDashBoard> createState() => _PersonalDashBoardState();
}

class _PersonalDashBoardState extends State<PersonalDashBoard> {
 bool isPhoneVerify = false;

  bool isEmailVerify=true;

  bool isKycVerify = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: sideBar,
      elevation: 15,
      child: Expanded(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Be",style: TextStyle(color: Colors.blue,fontSize: 40,fontWeight: FontWeight.bold),),
                    Text("Chain",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),)
                  ],
                )),
            ),
            //slider
            CarouselSlider(
              options: CarouselOptions(
                height: 100,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.95,
                scrollDirection: Axis.horizontal
              ),
              items: widget.privacySteps.map((i){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: sideBar,
                      borderRadius: new BorderRadius.all(const Radius.circular(15)),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1.5,
                        blurRadius: 4,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    ),
                    child: Builder(
                      builder: (BuildContext context){
                        String name = i[0];
                        switch(name) { 
                          case "email": { 
                            return Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  if (isEmailVerify != true) {
                                    Navigator.pop(context);
                                    emailverfy(context);
                                  } 
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left:14.0),
                                            child: Icon(Icons.email_rounded,size: 40,color: Colors.white,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Email Verification",style: TextStyle(color: Colors.white),),
                                                Text("erencanerel@gmial.com",style: TextStyle(color: Colors.white,fontSize: 10),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: isEmailVerify ? Icon(Icons.verified_rounded, color: Colors.blue) : Icon(Icons.warning_amber_rounded,color: Colors.red,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ); 
                          } 
                          break; 
                          case "phone": { 
                            return Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  if (isPhoneVerify != true) {
                                    Navigator.pop(context);
                                    phoneverfy(context);
                                  } 
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left:14.0),
                                            child: Icon(Icons.phone_android_rounded,size: 40,color: Colors.white,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Phone Verification",style: TextStyle(color: Colors.white),),
                                                Text("+90 531 920 17 62",style: TextStyle(color: Colors.white,fontSize: 10),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: isPhoneVerify ? Icon(Icons.verified_rounded, color: Colors.blue) : Icon(Icons.warning_amber_rounded,color: Colors.red,size: 40.0,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ); 
                          } 
                          break; 
                          case "KYC":{ 
                            return Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SecondRoute()),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left:14.0),
                                            child: Icon(Icons.person_off_rounded,size: 40,color: Colors.white,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("KYC Verification",style: TextStyle(color: Colors.white),),
                                                Text("Enable KYC to verify wallets",style: TextStyle(color: Colors.white,fontSize:10),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: i[2] == "verified" ? Icon(Icons.verified_rounded, color: Colors.blue) : Icon(Icons.warning_amber_rounded,color: Colors.red,size: 40.0,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ); 
                          }
                          break; 
                        }
                        return Container(
                          child: Text(name),
                        );
                      }
                    ),
                  ),
                );
              }).toList(), 
            ),
            ListTile(
              leading: Icon(Icons.link_outlined,color: Colors.white,),
              textColor: Colors.white,
              title: Text('BlockChain'),
            ),
            ListTile(
              leading: Icon(Icons.shield_rounded,color: Colors.white,),
              textColor: Colors.white,
              title: Text("Privacy & Protection"),    
            ),
            SizedBox(height: 260,),
            ListTile(
                leading: Icon(Icons.settings,color: Colors.white,),
                textColor: Colors.white,
                title: Text("Settings"),
              ),GestureDetector(
                child: ListTile(
                    leading: Icon(Icons.logout_outlined ,color: Colors.white,),
                    textColor: Colors.white,
                    title: Text("Log Out"),
                  ),
                  onTap: ()=>{
                    
                    logUserOut(),
    Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()))
                  },
              )
          ],
        ),
      ),
    );
  }
  Future<void> logUserOut() async {
                      final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'),version: 1,);

                      final db = await database;
                      // Remove the Dog from the database.
                      await db.rawDelete('DELETE FROM auth');
                    }

  Future<dynamic> phoneverfy(BuildContext context) {
    return showModalBottomSheet(
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (BuildContext context){
      return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:  <Widget>[
                Text("Phone Verification",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                TextFormField(
                    controller: null,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                      ],
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.phone_iphone_rounded,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                      child: FlatButton(
                        onPressed: (){
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue
                          ),
                          child: Center(
                            child: Text("Verify",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
    });
  }

  Future<dynamic> emailverfy(BuildContext context) {
    return showModalBottomSheet(
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (BuildContext context){
      return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:  <Widget>[
                Text("Email Verification",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                TextFormField(
                    controller: null,
                    style: TextStyle(color: Colors.white),
                    
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.mail_outline_outlined,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                      child: FlatButton(
                        onPressed: (){
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue
                          ),
                          child: Center(
                            child: Text("Verify",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
    });
  }
}



//kyc pages
class SecondRoute extends StatefulWidget {

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}
class _SecondRouteState extends State<SecondRoute> {
  String countryCode;

   TextEditingController first_name = TextEditingController();
   TextEditingController last_name = TextEditingController();
   TextEditingController id_number = TextEditingController();
   TextEditingController address = TextEditingController();
   TextEditingController birth_date = TextEditingController();
   

  List gender=["Male","Female","Other"];
  String gender_final;
  String select_gender;
  
    
    @override
    String countryFinal;
    var country;
    void changeName(country){
      String newCountry = country;
      setState(() {
        countryFinal = newCountry;
        country = newCountry;
        countryCode = country;
      });
      print(countryCode);
    }
    void initState() {
      super.initState();
      
    }
  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('KYC Verification'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background
        ),
        child: Padding(
          padding: const EdgeInsets.only(right:30.0,left: 30.0,top:50),
            child: Column(
              children: [
                TextFormField(
                    controller: first_name,
                    
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_add_alt ,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "First Name",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: last_name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_add_alt_1_outlined ,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Last Name",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: id_number,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                      ],
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.confirmation_number_outlined,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Identity Number",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: birth_date,
                    
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined ,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Birth Date",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: address,
                    
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city_outlined ,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      addRadioButton(0, 'Male'),
                      addRadioButton(1, 'Female'),
                      addRadioButton(2, 'Others'),
                    ],
                  ),
                  
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration:InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    labelText: "Country of Origin",
                    suffix: CountryListPick(
                      appBar: AppBar(
                        backgroundColor: background,
                        title: Text('Select your Country'),
                      ),
                      theme: CountryTheme(
                        isShowFlag: true,
                        isShowTitle: true,
                        isShowCode: true,
                        isDownIcon: true,
                        showEnglishName: true,
                      ),
                      initialSelection: '+90',
                      onChanged: (CountryCode code) {
                        
                        changeName(code.name);
                        country = code.name;
                        
                        
                      },
                      useUiOverlay: true,
                      useSafeArea: false
                      ),
                  )),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left:50.0,right: 50.0,top: 30),
                    child: Center(
                      child: FlatButton(
                        onPressed: (){
                          check(first_name.text, last_name.text, id_number.text, gender_final, country,birth_date.text,address.text);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue
                          ),
                          child: Center(
                            child: Text("Continue",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),  
      ),
    );
  }
  Row addRadioButton(int btnValue, String title) {
    return Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: <Widget>[
        Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
        disabledColor: Colors.blue
      ),
      child:Radio(
          activeColor: shadePurple,
          value: gender[btnValue],
          groupValue: select_gender,
          onChanged: (value){
            setState(() {
              gender_final = value;
              select_gender=value;
              print(select_gender);
            });
          },
        ),
    ),
    Text(title,style: TextStyle(color: Colors.white),)
    
  ],
);
 }

 check(first_name,last_name,id_number,gender,country,birth_date,location){
   
   Navigator.push(context,MaterialPageRoute(builder: (context) => ThirdRoute(first_name,last_name,id_number,gender_final,country,birth_date,location)),);
 }








 
}
class ThirdRoute extends StatefulWidget {
  
  final String first_name;
  final String last_name;
  final String id_number;
  final String country_name;
  final String gender_value;
  final String birth_date;
  final String address;
  const ThirdRoute(this.first_name, this.last_name, this.id_number , this.gender_value, this.country_name, this.birth_date, this.address);

  @override
  State<ThirdRoute> createState() => _ThirdRouteState();
}
class _ThirdRouteState extends State<ThirdRoute> {
  
  File image_front;
  File image_back;
  File image_face;
  bool done;
  @override
  void initState() {
    print(widget.first_name);
    super.initState();
    
  }
  Future pickImage_front() async{
    try {
      final image =await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      print(getFileSizeString(bytes: imageTemp.lengthSync()));
      setState(() {
        this.image_front = imageTemp;
        check_filled();
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  Future pickImage_back() async{
    try {
      final image =await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      print(getFileSizeString(bytes: imageTemp.lengthSync()));
      setState(() {
        this.image_back = imageTemp;
        check_filled();
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  Future pickImage_face() async{
    try {
      final image =await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      print(getFileSizeString(bytes: imageTemp.lengthSync()));
      setState(() {
        this.image_face = imageTemp;
        check_filled();
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  static String getFileSizeString({@required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
  Future takeImage_front() async{
    final image =await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      this.image_front = imageTemp;
      check_filled();
    });
  }
  Future takeImage_back() async{
    final image =await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      this.image_back = imageTemp;
      check_filled();
    });
  }
  Future takeImage_face() async{
    final image =await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      this.image_face = imageTemp;
      check_filled();
    });
  }
  check_filled(){
    if(image_front != null || image_back != null || image_face != null){
      setState(() {
        this.done = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('KYC Verification'),
      ),
      body: Container(
        child: Column(
          children: [
              Center(
                child: SizedBox(
                  height: 500,
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:80,left:20,right:20),
                        child: SizedBox(
                          width: 340,
                          child: Container(
                            child: image_front != null ? 
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 380,
                                    child: Container(
                                      child: Image.file(image_front,width: 200,height: 300,fit: BoxFit.cover,),
                                    ), 
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_front();
                                        
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            :
                            Stack(
                                children: [
                                  Center(
                                    child:SizedBox(
                                        width: 380,
                                        child: Container(
                                          child: Image.asset('assets/id_front.jpeg',width: 300,height: 300,),
                                        ), 
                                    ),
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_front();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )        
                          ),
                        ),
                        
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:80,left:20,right:20),
                        child: SizedBox(
                          width: 340,
                          child: Container(
                            child: image_back != null ? 
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 380,
                                    child: Container(
                                      child: Image.file(image_back,width: 200,height: 300,fit: BoxFit.cover,),
                                    ), 
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_back();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            :
                            Stack(
                                children: [
                                  Center(
                                    child:SizedBox(
                                        width: 380,
                                        child: Container(
                                          child: Image.asset('assets/id_back.jpeg',width: 300,height: 300,),
                                        ), 
                                    ),
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_back();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )        
                          ),
                        ),
                        
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:80,left:20,right:20),
                        child: SizedBox(
                          width: 340,
                          child: Container(
                            child: image_face != null ? 
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 380,
                                    child: Container(
                                      child: Image.file(image_face,width: 200,height: 300,fit: BoxFit.cover,),
                                    ), 
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_face();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            :
                            Stack(
                                children: [
                                  Center(
                                    child:SizedBox(
                                        width: 380,
                                        child: Container(
                                          child: Image.asset('assets/with_face.jpeg',width: 300,height: 300,),
                                        ), 
                                    ),
                                  ),
                                  Positioned(
                                    top: 280,
                                    right: -20,
                                    child: FlatButton(
                                      onPressed: (){
                                        getImage_face();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )        
                          ),
                        ),
                        
                      ),
                    ],
                  ),
                ),
              ),
            
            FlatButton(
              onPressed: (){
                done != true ? null :_asyncFileUpload();
              },
              child: Container(
                height: 50,
                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: done != true ? Colors.grey :Colors.blue
                  ),
                  child: Center(
                    child: done != true ? 
                    Text("Select all photos",style: TextStyle(color: Colors.white),)
                    :Text("DONE",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }
  
    success(){
    showSimpleNotification(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Success!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
          Text("Welcome back!",style: TextStyle(color: Colors.white,fontSize: 16),)
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

  _asyncFileUpload() async{
    String id;
    Future<List<Auth>> readAuth() async{
      final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'));
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('auth');
    print("a");
      return List.generate(maps.length, (i){
        print(maps.length);
        id = maps[i]['id'];
        print(id);
        return Auth(
          id: maps[i]['id']
        );
      });
    }
    await readAuth();
    //create multipart request for POST or PATCH method
    print(id.runtimeType);
    var url = "https://a5aa-176-90-205-154.eu.ngrok.io/kyc/subsphoto/$id";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    //add text fields
    var pic = await http.MultipartFile.fromPath("file", this.image_face.path);
    var pic2 = await http.MultipartFile.fromPath("file_2", this.image_face.path);
    var pic3 = await http.MultipartFile.fromPath("file_3", this.image_face.path);
    //add multipart to request
    request.files.add(pic);
    request.fields["address"] = widget.address;
    request.fields["birthdate"] = widget.birth_date;
    request.files.add(pic2);
    request.files.add(pic3);
    request.fields["firstName"] = widget.first_name;
    request.fields["lastName"] = widget.last_name;
    request.fields["identityNumber"] = widget.id_number;
    request.fields["gender"] = widget.gender_value;
    
    request.fields["phoneNumber"] = "5319201762" ;
    //create multipart using filepath, string or bytes
    
    var response = await request.send();
  print(response);
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    if(response.statusCode == 200){
      success();
      int count = 0; 
      Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()));

    }else{
      failed();
    }
  }

  void getImage_front() {
    showModalBottomSheet(
      context: context, 
      shape: const RoundedRectangleBorder(
        
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        )
      ),
      builder: (context){
        return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              ListTile(
                leading: Icon(Icons.photo_album_outlined,color: Colors.white,size: 30,),
                title: Text("Select from Gallery",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  pickImage_front();
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 30,),
                title: Text("Take Photo",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  takeImage_front();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void getImage_back(){
    showModalBottomSheet(
      context: context, 
      shape: const RoundedRectangleBorder(
        
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        )
      ),
      builder: (context){
        return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              ListTile(
                leading: Icon(Icons.photo_album_outlined,color: Colors.white,size: 30,),
                title: Text("Select from Gallery",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  pickImage_back();
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 30,),
                title: Text("Take Photo",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  takeImage_back();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void getImage_face(){
    showModalBottomSheet(
      context: context, 
      shape: const RoundedRectangleBorder(
        
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        )
      ),
      builder: (context){
        return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              ListTile(
                leading: Icon(Icons.photo_album_outlined,color: Colors.white,size: 30,),
                title: Text("Select from Gallery",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  pickImage_face();
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 30,),
                title: Text("Take Photo",style: TextStyle(color: Colors.white,fontSize: 20),),
                onTap: (){
                  takeImage_face();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
  
}



