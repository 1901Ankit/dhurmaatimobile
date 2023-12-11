import 'dart:convert';

import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/product-management/products.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
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
import '../../Constants/constants.dart';
import '../cart_screen.dart';
import '../login_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';

class MyProductsList extends StatefulWidget {
  const MyProductsList({Key? key}) : super(key: key);

  @override
  State<MyProductsList> createState() => _MyProductsListState();
}

class _MyProductsListState extends State<MyProductsList> {
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

  Future getDetails(BuildContext context) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);

    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/my-raw-materials'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constant.BackGround_Image),
          fit: BoxFit.cover,
        ),
      ),
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
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "   Raw Product's List ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              object.isEmpty
                  ? Center(
                      child: Text("No Raw Products Available"),
                    )
                  : ListView.builder(
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: object.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            hoverColor: Colors.green[300],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductsList(
                                        object[index]["raw_material_id"],
                                        object[index]["products"])),
                              );
                            },
                            child: Card(
                              // color: Colors.green.shade400,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30),
                              elevation: 5,
                              child: SizedBox(
                                height: 180,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Expanded(
                                    //   child:
                                    Container(
                                      // width: 300,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(25, 14, 7, 0.9),
                                        // borderRadius:
                                        //     BorderRadius.only(
                                        //         bottomLeft: Radius
                                        //             .circular(
                                        //                 4.0),
                                        //         bottomRight: Radius
                                        //             .circular(
                                        //                 4.0))
                                      ),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment
                                        //         .center,
                                        children: [
                                          SizedBox(width: 20),
                                          Text(
                                            "${object[index]["raw_material_name"]}"
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // ),
                                    SizedBox(height: 20),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 20, right: 20),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //           style: TextStyle(
                                    //             fontFamily: 'Poppins-Bold',
                                    //             fontSize: 13,
                                    //             // color: Colors.white,
                                    //           ),
                                    //           textAlign: TextAlign.left,
                                    //           "Raw Product Id"),
                                    //       Text(
                                    //           style: TextStyle(
                                    //             fontFamily: 'Poppins',
                                    //             fontSize: 13,
                                    //             // color: Colors.white,
                                    //           ),
                                    //           textDirection: TextDirection.ltr,
                                    //           textAlign: TextAlign.right,
                                    //           "eh2#ub7998jde"),
                                    //     ],
                                    //   ),
                                    // ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Bold',
                                                fontSize: 13,
                                                // color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                              "Product Name"),
                                          Text(
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                // fontSizeMyProducts // color: Colors.white,
                                              ),
                                              textDirection: TextDirection.ltr,
                                              textAlign: TextAlign.right,
                                              "${object[index]["raw_material_name"]}"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Bold',
                                                fontSize: 13,
                                                // color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                              "Associated Products  "),
                                          Text(
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                // color: Colors.white,
                                              ),
                                              textDirection: TextDirection.ltr,
                                              textAlign: TextAlign.right,
                                              "${object[index]["product_count"]}"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Bold',
                                                  fontSize: 13,
                                                  // color: Colors.white,
                                                ),
                                                textAlign: TextAlign.left,
                                                "Total Quantity"),
                                            Text(
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  // color: Colors.white,
                                                ),
                                                textDirection:
                                                    TextDirection.ltr,
                                                textAlign: TextAlign.right,
                                                "${object[index]["quantity"]} Kg"),
                                          ],
                                        )),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
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
                                              right: 10, top: 10),
                                          child: Text("View More "),
                                        ))
                                    // Container(
                                    //     margin:
                                    //         EdgeInsets.only(left: 20, right: 20),
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         Text(
                                    //             style: TextStyle(
                                    //               fontFamily: 'Poppins-Bold',
                                    //               fontSize: 13,
                                    //               // color: Colors.white,
                                    //             ),
                                    //             textAlign: TextAlign.left,
                                    //             "Payment Status"),
                                    //         Text(
                                    //             style: TextStyle(
                                    //               fontFamily: 'Poppins',
                                    //               fontSize: 13,
                                    //               // color: Colors.white,
                                    //             ),
                                    //             textDirection: TextDirection.ltr,
                                    //             textAlign: TextAlign.right,
                                    //             "Success"),
                                    //       ],
                                    //     )),
                                    // SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ));
                      })
            ],
          )),
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
        // ),
      ),
    );
  }
}
