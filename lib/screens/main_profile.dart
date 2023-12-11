import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:async';
import 'package:dhurmaati/screens/policies/privacy-policy.dart';
import 'package:dhurmaati/screens/policies/terms-and-conditions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dhurmaati/screens/my-subscription-list.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/edit_profile.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/product-management/my_products.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/constants.dart';
import 'main_dashboard_page.dart';
import 'orders_screen.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

Future logout(BuildContext context, String number) async {
  String num = number.replaceAll('+91', '');
  print(num);
  final prefManager = await SharedPreferences.getInstance();
  String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
  print(login_token);
  final response = await http.post(
    Uri.parse('${Constant.KEY_URL}/api/logout'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $login_token',
    },
    body: jsonEncode({
      'contact_no': num,
      // 'group_id': group,
    }),
  );

  if (response.statusCode == 200) {
    // print("dnfcdfmd $title");
    var res = jsonDecode(response.body);
    print(res);
    var respon = res["response"];
    var message = respon["message"];
    prefManager.remove(Constant.KEY_LOGIN_TOKEN);
    prefManager.remove(Constant.KEY_IS_LOGIN);
    prefManager.remove(Constant.KEY_AVATAR_URL);
    prefManager.remove(Constant.KEY_USER_GROUP);
    prefManager.remove(Constant.KEY_USER_ID);
    //  // prefManager.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => DashBoard()), (route) => false);
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else if (response.statusCode > 200) {
    var data = jsonDecode(response.body);

    var rest = data["response"];
    var message1 = rest["message"];
    print(data);
    print(message1);
    Fluttertoast.showToast(
      msg: "$message1",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
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

class _MyProfileState extends State<MyProfile> {
  int _selectedScreenIndex = 3;
  var number = FirebaseAuth.instance.currentUser?.phoneNumber;
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
      Uri.parse('${Constant.KEY_URL}/api/get-profile'),
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
        object = [message];
        // print(object[0]);
      });
      // Fluttertoast.showToast(
      //   msg: "$message",
      //   toastLength: Toast.LENGTH_SHORT,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green[400],
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
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
          body: Container(
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '  Account Preferences'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        isLogin != true
                            ? new Container()
                            : object.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: Row(
                                          children: [
                                            CircleAvatar(
                                              child: GestureDetector(
                                                onTap: () {},
                                                //  () async {
                                                // await showDialog(
                                                //     context: context,
                                                //     builder: (_) =>
                                                //         imageDialog(
                                                //             ' Profile Picture',
                                                //             object[0]
                                                //                 ["avatar"],
                                                //             context));
                                                // },
                                              ),
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      object[0]["avatar"]),
                                              radius: 40,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "${object[0]["name"]}"
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins-Bold',
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )
                                            // SizedBox(
                                            //   width: 50.0,
                                            ),
                                        SizedBox(
                                            height: 40,
                                            // width: 80,
                                            child: OutlinedButton.icon(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                              label: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              onPressed: () async {
                                                var details = [object[0]];
                                                final prefManager =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String? group = prefManager
                                                    .getString(Constant
                                                        .KEY_USER_GROUP);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyEditProfile(
                                                              details)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.green),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: isLogin == true
                                    ? () async {
                                        var details = [object[0]];
                                        final prefManager =
                                            await SharedPreferences
                                                .getInstance();
                                        String? group = prefManager
                                            .getString(Constant.KEY_USER_GROUP);
                                        bool? isLogin = prefManager
                                            .getBool(Constant.KEY_IS_LOGIN);
                                        // isLogin
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyEditProfile(details)),
                                        );
                                      }
                                    : () {
                                        Fluttertoast.showToast(
                                          msg:
                                              "You are currently not logged In please login to edit details",
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      },
                                child: Row(
                                  children: [
                                    // FaIcon(FontAwesomeIcons.addressCard),
                                    // // Icon(Icons.shopping_cart_outlined),
                                    // SizedBox(
                                    //   width: 4.0,
                                    // ),
                                    Text(
                                      "My Profile",
                                      style: TextStyle(
                                          // color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 0.15,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrdersList()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "My Orders",
                                      style: TextStyle(
                                          // color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 0.15,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MysubscriptionList()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "My Subscriptions",
                                      style: TextStyle(
                                          // color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 0.15,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        group == "Seller"
                            ? Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // const url =
                                        //     'http://maati.allcanfarm.com/api/privacy-policy.html';
                                        // if (await canLaunch(url)) {
                                        //   await launch(url);
                                        // } else {
                                        //   throw 'Could not launch $url';
                                        // }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyProductsList()),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          // FaIcon(FontAwesomeIcons.file),
                                          // // Icon(Icons.share),
                                          // SizedBox(
                                          //   width: 4.0,
                                          // ),
                                          Text(
                                            "My Products",
                                            style: TextStyle(
                                                // color: Colors.grey,
                                                fontFamily: 'Poppins',
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : new Container(),
                        group == "Seller"
                            ? Divider(
                                height: 20,
                                thickness: 0.5,
                                endIndent: 0,
                                color: Colors.black,
                              )
                            : new Container(),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // const url =
                                  //     'https://maati.allcanfarm.com/api/privacy-policy.html';
                                  // if (await canLaunch(url)) {
                                  //   await launch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                    Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PrivacyPolicy()),
                                              );
                                  // const url =
                                  //     'https://maati.allcanfarm.com/api/privacy-policy.html';
                                  // if (await launch(url)) {
                                  //   await canLaunch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                },
                                child: Row(
                                  children: [
                                    // FaIcon(FontAwesomeIcons.phone),
                                    // // Icon(Icons.thumb_up_alt_outlined),
                                    // SizedBox(
                                    //   width: 4.0,
                                    // ),
                                    Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                          // color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Divider(
                        //   height: 20,
                        //   thickness: 0.5,
                        //   endIndent: 0,
                        //   color: Colors.black,
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.only(left: 10, right: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       InkWell(
                        //         // onTap: () {
                        //         //   Navigator.push(
                        //         //     context,
                        //         //     MaterialPageRoute(
                        //         //         builder: (context) => Settings()),
                        //         //   );
                        //         // },
                        //         child: Row(
                        //           children: [
                        //             // FaIcon(FontAwesomeIcons.phone),
                        //             // // Icon(Icons.thumb_up_alt_outlined),
                        //             // SizedBox(
                        //             //   width: 4.0,
                        //             // ),
                        //             Text(
                        //               "Contact Us",
                        //               style: TextStyle(
                        //                   // color: Colors.grey,
                        //                   fontFamily: 'Poppins',
                        //                   fontSize: 15),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Divider(
                          height: 20,
                          thickness: 0.15,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                // onTap: () async {
                                //   print(FirebaseAuth
                                //       .instance.currentUser!.phoneNumber);
                                //   // await FirebaseAuth.instance.signOut();
                                //   // Navigator.pushAndRemoveUntil(
                                //   //     context,
                                //   //     MaterialPageRoute(builder: (context) => HomeScreen()),
                                //   //     (route) => false);
                                //   logout(context, number.toString());
                                // },
                                child: Row(
                                  children: [
                                    // Icon(Icons.logout_outlined),
                                    // SizedBox(
                                    //   width: 4.0,
                                    // ),
                                    InkWell(
                                      onTap: isLogin == true
                                          ? () async {
                                              logout(
                                                  context, number.toString());
                                            }
                                          : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                              );
                                            },
                                      child: Text(
                                        "${isLogin == true ? "Logout" : "Login"}",
                                        style: TextStyle(
                                            // color: Colors.grey,/
                                            // fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 0.5,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                
                                onTap: () async {
                                  Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TermsAndConditions()),
                                              );
                                  // const url =
                                  //     'https://maati.allcanfarm.com/api/terms-and-conditions.html';
                                  // if (await launch(url)) {
                                  //   await canLaunch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                  // const url =
                                  //     'https://www.allcanfarm.com/terms-and-conditions.html';
                                  // if (await canLaunch(url)) {
                                  //   await launch(url);
                                  // } else {
                                  //   throw 'Could not launch $url';
                                  // }
                                },
                                child: Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Poppins-Bold'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                },
                                child: Text(
                                  "About App",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Poppins-Bold'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ))),
          ),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('About Dhurr Maati',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
          )),
      content: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Text(Constant.KEY_APP_DESCRIPTION,
            textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'Poppins-Light', fontSize: 14)),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
      // ),
    );
  }
}
