import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhurmaati/screens/admin-product-management/edit-product.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/product-management/edit_product_screen.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product-management/my_products.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/constants.dart';
import '../cart_screen.dart';
import '../login_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import 'package:http/http.dart' as http;

class AllProductsList extends StatefulWidget {
  // const AllProductsList({Key? key}) : super(key: key);
 


  @override
  State<AllProductsList> createState() => _AllProductsListState();
}

class _AllProductsListState extends State<AllProductsList> {
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
    getNotifications(context);
    getDetails(context);
    // }
  }

  List<dynamic> obj = [];
  String? group;

  Future getDetails(BuildContext context) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);
    setState(() {
      group = prefManager.getString(Constant.KEY_USER_GROUP);
    });

    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-category'),
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
        obj = message;
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

  var arr = [
    {'img': Constant.Banner_Image1},
    {'img': Constant.Banner_Image2},
    {'img': Constant.Banner_Image3},
  ];

  Future deleteProduct(BuildContext context, int product_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response =
        await http.delete(Uri.parse('${Constant.KEY_URL}/api/delete-product'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"product_id": product_id}));

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
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => new MyProductsList()),
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

  Future suspendProduct(BuildContext context, int product_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response =
        await http.patch(Uri.parse('${Constant.KEY_URL}/api/suspend-product'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"product_id": product_id}));

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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new MyProductsList()),
          (route) => false);
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
  List notificationList =[];
   Future getNotifications(
    BuildContext context,
  ) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-all-products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      var product = message["products"];
      print(product);
      // print(message);
      setState(() {
        notificationList = product;
        print(notificationList);
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


  @override
  Widget build(BuildContext context) {
    print(notificationList);
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " All Products",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(
                    //     height: 40,
                    //     // width: 80,
                    //     child: OutlinedButton.icon(
                    //       icon: Icon(
                    //         Icons.add,
                    //         color: Colors.green,
                    //         size: 16,
                    //       ),
                    //       label: Text(
                    //         "Add",
                    //         style: TextStyle(color: Colors.green),
                    //       ),
                    //       onPressed: () async {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   AddProductPage(obj, widget.raw_id)),
                    //         );
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         side: BorderSide(width: 1.5, color: Colors.green),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(32.0),
                    //         ),
                    //       ),
                    //     )),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // InkWell(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => AddProductPage(
              //                 obj, widget.object[0]["raw_material_id"])),
              //       );
              //     },
              //     child: Text(
              //       "Add New Product",
              //       style: TextStyle(
              //         fontFamily: 'Poppins-Light',
              //         fontSize: 20,
              //         decoration: TextDecoration.underline,
              //       ),
              //     )),
              // SizedBox(
              //   height: 20,
              // ),
              notificationList.isEmpty
                  ? Center(
                      child: Text("No Products Available"),
                    )
                  : ListView.builder(
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              // List<dynamic> formDb = [
                              //   widget.datapass.farmes[index]
                              // ];
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           widget.group == "Super_Admin" ||
                              //                   widget.group == "coordinator"
                              //               ? SelfFarm(formDb, widget.group,
                              //                   widget.token)
                              //               : Farm(formDb, widget.group,
                              //                   widget.token)),
                              // );
                            },
                            child: Card(
                              // color: widget.datapass.farmes[index]["status"]
                              //     ? Colors.green.shade300
                              //     : Colors.blue.shade300,
                              margin: EdgeInsets.all(10),
                              elevation: 5,
                              // child: SizedBox(
                              //   // padding: EdgeInsets.all(20),
                              //   height: 350,
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 14, 7, 0.9),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(width: 20),
                                        Text(
                                          "    ${notificationList[index]["product_name"]}"
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Bold',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        PopupMenuButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.ellipsisVertical,
                                              color: Colors.white,
                                            ),
                                            // add icon, by default "3 dot" icon
                                            // icon: Icon(Icons.book)
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text("Edit Product"),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child:
                                                      Text("Suspend Product"),
                                                )
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == 0) {
                                                List<dynamic> formDb = [
                                                 notificationList[index]
                                                ];
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProduct(
                                                              obj, formDb)),
                                                );
                                              } else if (value == 1) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      width: 300,
                                                      height: 300,
                                                      child: AlertDialog(
                                                        title: Text(
                                                          'Suspend Product',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Bold'),
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete the product',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins'),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            textColor:
                                                                Colors.black,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'CANCEL',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            textColor:
                                                                Colors.black,
                                                            onPressed: () {
                                                              suspendProduct(
                                                                  context,
                                                                 notificationList[
                                                                          index]
                                                                      [
                                                                      "product_id"]);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'YES',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                                // deletecategory(
                                                //     context,
                                                //     categoryList[index]
                                                //         ["category_id"]);
                                              } else if (value == 2) {
                                                print(
                                                    "Logout menu is selected.");
                                              }
                                            }),
                                        // InkWell(
                                        //     onTap: () {
                                        //       List<dynamic> formDb = [
                                        //         widget.object[index]
                                        //       ];
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 EditProductPage(
                                        //                     obj, formDb)),
                                        //       );
                                        //     },
                                        //     child: Icon(
                                        //       Icons.edit_note,
                                        //       color: Colors.white,
                                        //     )
                                        //     //  Text(
                                        //     //   "Edit   ".toUpperCase(),
                                        //     //   style: TextStyle(
                                        //     //     fontFamily: 'Poppins-Bold',
                                        //     //     color: Colors.white,
                                        //     //     fontSize: 16,
                                        //     //   ),
                                        //     // ),
                                        //     ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // ),
                                  CarouselSlider.builder(
                                    itemCount: notificationList[index]["product_images"].length,
                                    itemBuilder: (BuildContext context, int ind,
                                        int realidx) {
                                      return Container(
                                        margin: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${notificationList[index]["product_images"][ind]["url"]}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 200.0,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 3 / 4,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      viewportFraction: 0.94,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Price/Package(MRP)",
                                          style: TextStyle(
                                            // color: Colors.white,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "₹ ${notificationList[index]["unit_price"]}")
                                        // "${widget.datapass.farmes[index]["type"] == "crop" ? "${widget.datapass.farmes[index]["remaining_area"]} Sq Mtr" : "${widget.datapass.farmes[index]["remaining_tree"]} trees"}"),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Quantity/package",
                                          style: TextStyle(
                                            // color: Colors.white,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              // color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "${notificationList[index]["net_wt"]} g"),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Available Packages",
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              // color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                // color: Colors.white,
                                              ),
                                              textDirection: TextDirection.ltr,
                                              textAlign: TextAlign.right,
                                              "${notificationList[index]["quantity"]} packages"
                                              // "${widget.datapass.farmes[index]["sowing_month"]}"
                                              ),
                                        ]),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            style: TextStyle(
                                              // color: Colors.white,
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.left,
                                            "Selling Prize"),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "₹ ${notificationList[index]["new_mrp"]}"
                                            // "${widget.datapass.farmes[index]["harvest_month"]}"
                                            ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            style: TextStyle(
                                              // color: Colors.white,
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.left,
                                            "Available In:"),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "${notificationList[index]["availability"]}"
                                            // "${widget.datapass.farmes[index]["harvest_month"]}"
                                            ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                              // )
                              // ),
                            ));
                      })
            ],
          )),
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }
}
