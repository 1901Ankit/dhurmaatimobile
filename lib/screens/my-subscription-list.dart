import 'dart:convert';

import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constants/constants.dart';
import '../widget/appBarDrawer.dart';
import '../widget/appBarTitle.dart';
import '../widget/bottomnavigation.dart';
import 'main_dashboard_page.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

class MysubscriptionList extends StatefulWidget {
  const MysubscriptionList({Key? key}) : super(key: key);

  @override
  State<MysubscriptionList> createState() => _MysubscriptionListState();
}

class _MysubscriptionListState extends State<MysubscriptionList> {
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
    getDetails(context);
    // }
  }

  List<dynamic> object = [];
  String? group;

  bool? isLogin;
  Future getDetails(BuildContext context) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);
    setState(() {
      group = prefManager.getString(Constant.KEY_USER_GROUP);

      isLogin = prefManager.getBool(Constant.KEY_IS_LOGIN);
      print(group);
      print(">>>>>>>>>>>>>>>");
      print(isLogin);
      print(">>>>>>>>>>>>>>>");
    });

    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/my-subscriptions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      print(res);
      var respon = res["response"];
      var message = respon["message"];
      setState(() {
        object = message;
        print(object);
      });
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
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => DashBoard()),
        //     (route) => false);
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
        msg: "Internal Server Error Please try again",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to create album.');
    }
  }

  Future pauseSubscription(BuildContext context, int id, bool status) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);

    final response = await http.patch(
        Uri.parse('${Constant.KEY_URL}/api/pause-subscription'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $login_token',
        },
        body: jsonEncode({"subscription_id": id, "is_active": status}));

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      print(res);
      var respon = res["response"];
      var message = respon["message"];
      // setState(() {
      //   object = message;
      //   // print(object);
      // });
      Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      getDetails(context);
      Navigator.pop(context);
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
        msg: "Internal Server Error Please try again",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to create album.');
    }
  }

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

  Future deleteSubscription(
      BuildContext context, int subscription_id, String reason) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.delete(
        Uri.parse('${Constant.KEY_URL}/api/delete-subscription'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $login_token',
        },
        body:
            jsonEncode({"subscription_id": subscription_id, 'reason': reason}));

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      // print(product);
      // print(message);
      // setState(() {
      //   categoryList = message;
      //   print(categoryList[3]);
      // });
      getDetails(context);
      Navigator.pop(context);
      setState(() {
        _reasonController.text = '';
      });
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => new BannerList()),
      //     (route) => false);
      Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

  showPausesubscription(
      BuildContext context, int subscription_id, bool status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          height: 300,
          child: AlertDialog(
            title: Text(
              status ? 'Resume Subscription' : 'Pause Subscription',
              style: TextStyle(fontFamily: 'Poppins-Bold'),
            ),
            content: Text(
              status
                  ? 'Are you sure you want to resume this subscriptions ?'
                  : 'Are you sure you want to pause this subscriptions ?',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              FlatButton(
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              FlatButton(
                textColor: Colors.black,
                onPressed: () {
                  // deleteZone(context, zone_id);
                  pauseSubscription(context, subscription_id, status);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  FocusNode myFocusNode = new FocusNode();

  final TextEditingController _reasonController = TextEditingController();
  showDeletesubscription(BuildContext context, int subscription_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          // height: 300,
          child: AlertDialog(
            title: Text(
              'Delete Subscription',
              style: TextStyle(fontFamily: 'Poppins-Bold'),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Are you sure you want to delete this subscriptions ?',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _reasonController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.notes,
                          ),
                          prefixIconColor: myFocusNode.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelText: 'Reason',
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
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
              FlatButton(
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              FlatButton(
                textColor: Colors.black,
                onPressed: () {
                  deleteSubscription(
                      context, subscription_id, _reasonController.text);
                  // pauseSubscription(context, subscription_id, status);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Constant.BackGround_Image),
          fit: BoxFit.cover,
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
          body: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                  Duration(seconds: 1),
                  () {
                    getDetails(context);
                    setState(() {
                      _reasonController.text = '';
                    });
                  },
                );
              },
              child: Container(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  Subscriptions",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ]),
                  object.isEmpty
                      ? Container(
                          height: 300,
                          child:
                              Center(child: Text("No Subscription Available ")),
                        )
                      : ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: object.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Text('  Subscription:',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black45)),
                                        Text(
                                            'Daily ${object[index]['slot'] == 'MOR' ? "Morning" : "Evening"}',
                                            style: TextStyle(fontSize: 14.0)),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 5.0,
                                    color: Colors.black,
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: object[index]
                                            ["subscription_details"]
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int ind) {
                                      final product = object[index]
                                          ["subscription_details"][ind];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Image.network(product["image_url"],
                                                height: 100.0, width: 100.0),
                                            SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(product['product_name'],
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  SizedBox(height: 8.0),
                                                  Text(
                                                      'Qty: ${product['quantity']}',
                                                      style: TextStyle(
                                                          fontSize: 16.0)),
                                                  SizedBox(height: 8.0),
                                                  Text(
                                                      'Price: ₹${product['price']}',
                                                      style: TextStyle(
                                                          fontSize: 16.0)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "     Status: ${object[index]['is_active'] ? "Active" : "Paused"}"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    height: 5.0,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    // decoration:
                                    //     BoxDecoration(color: Colors.red.shade900),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDeletesubscription(
                                                context,
                                                object[index]
                                                    ["subscription_id"]);
                                          },
                                          child: Container(
                                            // width: 50,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: Colors.green,
                                          thickness: 2,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showPausesubscription(
                                                context,
                                                object[index]
                                                    ["subscription_id"],
                                                !object[index]["is_active"]);
                                          },
                                          child: Container(
                                            // width: 50,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  object[index]['is_active']
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  '${object[index]['is_active'] ? "Pause" : "Resume"} ',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                ],
              )))),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }
}
