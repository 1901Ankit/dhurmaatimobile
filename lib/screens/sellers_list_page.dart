import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/seller_profile_screen.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main_dashboard_page.dart';

class SellerList extends StatefulWidget {
  const SellerList({Key? key}) : super(key: key);

  @override
  State<SellerList> createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  int _selectedScreenIndex = 0;

  late List _screens;
  final TextEditingController _searchController = TextEditingController();

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
    getSellerList(context, '');
    // }
  }

  List<dynamic> categoryList = [];
  Future getSellerList(BuildContext context, String search) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-all-sellers/')
          .replace(queryParameters: {'search': search}),
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
      // print(message);
      setState(() {
        categoryList = message;
        // print(categoryList);
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
        body: categoryList.isEmpty
            ? Center(child: Text("No Seller Available"))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Text(
                              "Seller's List",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  // cursorHeight: 10,
                                  controller: _searchController,
                                  onChanged: (value) {
                                    // farmerList(value);
                                    getSellerList(context, value);
                                  },
                                  cursorColor: Colors.green,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 193, 63, 40))),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                      // suffixIcon: Container(
                                      //   padding: EdgeInsets.all(15),
                                      //   child:
                                      //       Image.asset('assets/images/search.png'),
                                      //   width: 18,
                                      // ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        // scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                List<dynamic> formDb = [categoryList[index]];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SellerProfile(formDb)),
                                );
                              },
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 30),
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
                                                    // AssetImage(
                                                    //     Constant.Banner_Image3),
                                                    CachedNetworkImageProvider(
                                                        '${categoryList[index]['avatar']}'),
                                                radius: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 15),
                                                child: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
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
                                                              color:
                                                                  Colors.black,
                                                              // fontWeight: FontWeight.w600,
                                                              fontFamily:
                                                                  'Poppins-Bold',
                                                              fontSize: 15),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              " ${categoryList[index]['name']}",
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
                                                              color:
                                                                  Colors.black,
                                                              // fontWeight: FontWeight.w600,
                                                              fontFamily:
                                                                  'Poppins-Bold',
                                                              fontSize: 15),
                                                        ),
                                                        Text(
                                                          '${categoryList[index]['city']} ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                          '${categoryList[index]['contact_no']}',
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
                                      Positioned(
                                          bottom: 10,
                                          right: 0,
                                          // alignment: Alignment.bottomRight,
                                          child: Container(
                                            // margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                top: 10, right: 20),
                                            child: Text("View More "),
                                          ))
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
