import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../widget/appBarTitle.dart';
import '../cart_screen.dart';
import '../main_dashboard_page.dart';

class DeliveryAgentList extends StatefulWidget {
  final String zone_name;
  final int id;
  DeliveryAgentList(this.zone_name, this.id);
  // const DeliveryAgentList({Key? key}) : super(key: key);

  @override
  State<DeliveryAgentList> createState() => _DeliveryAgentListState();
}

class _DeliveryAgentListState extends State<DeliveryAgentList> {
  int _selectedScreenIndex = 0;

  late List _screens;

  @override
  initState() {
    _screens = [
      {"screen": DashBoard(), "title": "DashBoard"},
      {"screen": CartPage(), "title": "Cart"},
      {"screen": OrdersList(), "title": "Orders"},
      {"screen": MyProfile(), "title": "My Account"}
    ];
    // getdata() {
    // getDashBoard(context);
    // getPosts(context);
    getDetails(context, widget.id);
    // }
  }

  List distributorList = [];
  Future getDetails(BuildContext context, int zone_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-distributors-by-zone/')
          .replace(queryParameters: {
        'zone_id': zone_id.toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      // print(product);
      print(message);
      setState(() {
        distributorList = message;
        print(distributorList);
      });

      // ntfile.writeAsStringSync(json.encode(message),
      //     flush: true, encoding: utf8, mode: FileMode.write);
    } else if (response.statusCode > 200) {
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];
      print(data);
      print(message1);
      var code = rest["code"];
      print(data);
      print(code);
      print(message1);
      if (code == 401) {
        //  // prefManager.clear();

        prefManager.remove(Constant.KEY_LOGIN_TOKEN);
        prefManager.remove(Constant.KEY_IS_LOGIN);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        Fluttertoast.showToast(
          msg: "$message1",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
            (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "$message1",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong please try again.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to create album.');
    }
  }
  // List<dynamic> buyerList = [];
  // Future getDetails(BuildContext context, String search) async {
  //   print("Reading from internet");

  //   final prefManager = await SharedPreferences.getInstance();
  //   String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
  //   final response = await http.get(
  //     Uri.parse('${Constant.KEY_URL}/api/get-all-users/')
  //         .replace(queryParameters: {'search': search}),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       // 'Authorization': 'Bearer $login_token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // print("dnfcdfmd $title");
  //     var res = jsonDecode(response.body);
  //     var resp = res["response"];
  //     var message = resp["message"];
  //     // var product = message["products"];
  //     // print(product);
  //     print(message);
  //     setState(() {
  //       buyerList = message;
  //     });

  //     // ntfile.writeAsStringSync(json.encode(message),
  //     //     flush: true, encoding: utf8, mode: FileMode.write);
  //   } else if (response.statusCode > 200) {
  //     var data = jsonDecode(response.body);

  //     var rest = data["response"];
  //     var message1 = rest["message"];
  //     print(data);
  //     print(message1);
  //     var code = rest["code"];
  //     print(data);
  //     print(code);
  //     print(message1);
  //     if (code == 401) {
  //       //  // prefManager.clear();

  //       Fluttertoast.showToast(
  //         msg: "$message1",
  //         toastLength: Toast.LENGTH_SHORT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red[400],
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "$message1",
  //         toastLength: Toast.LENGTH_SHORT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red[400],
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: "Something went wrong please try again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green[400],
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     throw Exception('Failed to create album.');
  //   }
  // }

  final TextEditingController _searchController = TextEditingController();

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _screens[_selectedScreenIndex]["screen"]),
    );
  }

  Future adddistributor(String name, int number, int zone_id) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/add-distributor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body:
          jsonEncode({"name": name, "contact_no": number, "zone_id": zone_id}),
    );
    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      print(message);
      // setState(() {
      //   zoneList = message;
      //   print(zoneList[0]);
      // });
      Navigator.pop(context);
      setState(() {
        _numberController.text = '';
        _nameController.text = '';
      });
      // getDetails(context);
      getDetails(context, widget.id);
      // ntfile.writeAsStringSync(json.encode(message),
      //     flush: true, encoding: utf8, mode: FileMode.write);
    } else if (response.statusCode > 200) {
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];
      print(data);
      print(message1);
      var code = rest["code"];
      print(data);
      print(code);
      print(message1);
      if (code == 401) {
        //  // prefManager.clear();

        prefManager.remove(Constant.KEY_LOGIN_TOKEN);
        prefManager.remove(Constant.KEY_IS_LOGIN);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        Fluttertoast.showToast(
          msg: "$message1",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
            (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "$message1",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong please try again.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to create album.');
    }
  }

  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  addDistributorDialog(context, int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Add Distributor'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _nameController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_pin_sharp),
                          prefixIconColor: myFocusNode.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? Color.fromARGB(255, 193, 63, 41)
                                  : Colors.black),
                          labelText: 'Distributor Name',
                          // icon: Icon(
                          //   Icons.location_on,
                          //   color:,
                          // ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _numberController,
                        focusNode: myFocusNode2,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.tablet_android_sharp,
                          ),
                          prefixIconColor: myFocusNode2.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelText: 'Distributor Number',
                          labelStyle: TextStyle(
                              color: myFocusNode2.hasFocus
                                  ? Color.fromARGB(255, 193, 63, 41)
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    // your code
                    adddistributor(_nameController.text,
                        int.parse(_numberController.text), id);
                    // addZone(_zonenameController.text,
                    //     _zoneareaController.text);
                  }),
              RaisedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // your code
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(Constant.BackGround_Image),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: AppbarTitle(),
        ),
        drawer: Appbardrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Zone Delivery Agent's List",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              height: 40,
                              // width: 80,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                label: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () async {
                                  addDistributorDialog(context, widget.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.5, color: Colors.green),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                              )),
                        ]),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              distributorList.isEmpty
                  ? Container(
                      height: 350,
                      child: Center(
                          child: Text(
                        "No Distributor Available ",
                        style: TextStyle(fontSize: 18),
                      )))
                  : ListView.builder(
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: distributorList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {},
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Container(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 6),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 193, 63, 41),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ) // green shaped
                                            ),
                                        child: Text(
                                          " ${index + 1}.",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 0.5),
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  // await showDialog(
                                                  //     context: context,
                                                  //     builder: (_) => imageDialog(
                                                  //         '${farmerData[index]['name']} Profile Picture',
                                                  //         farmerData[index]['avatar'],
                                                  //         context));
                                                },
                                              ),
                                              backgroundImage:
                                                  //  AssetImage(
                                                  //     Constant.Banner_Image3),
                                                  CachedNetworkImageProvider(
                                                      // '${buyerList[index]['avatar']}'
                                                      'https://all-can-farm.s3.ap-southeast-1.amazonaws.com/avatar.png'),
                                              radius: 40,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                              child: Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .spaceBetween,
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Name : ',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            // fontWeight: FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins-Bold',
                                                            fontSize: 15),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            textAlign:
                                                                TextAlign.start,
                                                            " ${distributorList[index]["name"]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                // fontWeight: FontWeight.w600,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 15),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Location : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            // fontWeight: FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins-Bold',
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        '${widget.zone_name}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            // fontWeight: FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .spaceBetween,
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Phone No : ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Poppins-Bold'),
                                                      ),

                                                      Text(
                                                        '${distributorList[index]["contact_no"]}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      // /),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            // }
                            );
                      })
            ],
          ),
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }
}
