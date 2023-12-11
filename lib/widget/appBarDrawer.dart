import 'dart:convert';

import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/admin-product-management/products-list.dart';
import 'package:dhurmaati/screens/customer-order-management/customer_order_list.dart';
import 'package:dhurmaati/screens/customer-subscriptions.dart';
import 'package:dhurmaati/screens/delivery-agent-management/delivery-agent-list.dart';
import 'package:dhurmaati/screens/delivery-agent-management/delivery-order-list.dart';
import 'package:dhurmaati/screens/distributors_list.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/banner-management/banner_list_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/category_management/category_list_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/product-management/my_products.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/seller_customer_orders/customer_order_list_screen.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/screens/zone-management/zone-list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../screens/customer-order-management/customer-subscription-order-list.dart';
import '../screens/my-subscription-list.dart';

class Appbardrawer extends StatefulWidget {
  // late String? IsLogin;
  const Appbardrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<Appbardrawer> createState() => _AppbardrawerState();
}

class _AppbardrawerState extends State<Appbardrawer> {
  var number = FirebaseAuth.instance.currentUser?.phoneNumber;

  bool? IsLogin;
  @override
  void initState() {
    getData();
    getDetails(context);
    getProfileDetails(context);
  }

  getData() async {
    final prefManager = await SharedPreferences.getInstance();
    setState(() {
      IsLogin = prefManager.getBool(Constant.KEY_IS_LOGIN);
    });
    print(IsLogin);
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
          (route) => false);
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
        // 'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      print(res);
      var respon = res["response"];
      var message = respon["message"];
      setState(() {
        categoryList = message;
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

  List<dynamic> categoryList = [];
  Future getcategories(
    BuildContext context,
  ) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/shop-by-category'),
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
      // var product = message["products"];
      // print(product);
      // print(message);
      setState(() {
        categoryList = message;
        print(categoryList);
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
        // prefManager.clear();

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

  List<dynamic> object = [];
  // String? group;

  bool? isLogin;
  Future getProfileDetails(BuildContext context) async {
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

String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.black,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      width: MediaQuery.of(context).size.width-50,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 193, 63, 41),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: IsLogin == true
                  ? object.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${object[0]["avatar"]}'),
                              radius: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Welcome',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${object[0]["name"]}'.toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                          ],
                        )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/anita-austvika-q_5xb2lzHGU-unsplash.jpg'),
                          radius: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Welcome',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'User,'.toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        )
                      ],
                    ),
            ),
          ),
          Container(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0.65))),
            child: ListTile(
              title: const Text('Home',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                    (route) => false);
              },
            ),
          ),
          Container(
            // decoration:
            //     BoxDecoration(border: Border(bottom: BorderSide(width: 0.65))),
            child: ExpansionTile(
              title: const Text("Categories",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              children: [
                Container(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: categoryList.length,
                        // physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(width: 0.65))),
                            child: ListTile(
                              title: Text(
                                "    ${capitalizeAllWord(categoryList[index]["category_name"])}",
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductListPage(
                                          "category",
                                          categoryList[index]["category_id"])),
                                );
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => ProductListPage()),
                                //     (route) => false);
                              },
                            ),
                          );
                        })),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 0.65),
              top: BorderSide(width: 0.65),
            )),
            child: ExpansionTile(
              title: const Text('My Account',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 0.65))),
                  child: ListTile(
                    title: const Text('My Profile',
                        style: TextStyle(color: Colors.black45)),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()),
                          (route) => false);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 0.65))),
                  child: ListTile(
                    title: const Text('My Orders',
                        style: TextStyle(color: Colors.black45)),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersList()),
                          (route) => false);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 0.65))),
                  child: ListTile(
                    title: const Text('My Subscriptions',
                        style: TextStyle(color: Colors.black45)),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MysubscriptionList()),
                          (route) => false);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 0.65))),
                  child: ListTile(
                    title: const Text(
                      'Cart',
                      style: TextStyle(color: Colors.black45),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          group == "Seller"
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.65))),
                  child: ExpansionTile(
                    title: const Text("Setting's",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(width: 0.65))),
                        child: ListTile(
                          title: const Text("    Customer Orders",
                              style: TextStyle(color: Colors.black45)),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerOrdersList()),
                            );
                          },
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       border: Border(top: BorderSide(width: 0.65))),
                      //   child: ListTile(
                      //     title: const Text("    Customer's Transactions",
                      //         style: TextStyle(color: Colors.black45)),
                      //     onTap: () {
                      //       // Update the state of the app
                      //       // ...
                      //       // Then close the drawer
                      //       Navigator.pop(context);
                      //     },
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                          // bottom: BorderSide(width: 0.65),
                          top: BorderSide(width: 0.65),
                        )),
                        child: ExpansionTile(
                          title: const Text('    Catalog',
                              style: TextStyle(color: Colors.black)),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Product Management",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProductsList()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : new Container(),
          group == 'Distributor'
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.65))),
                  child: ExpansionTile(
                    title: const Text("Settings",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(width: 0.65))),
                        child: ListTile(
                          title: const Text("    My Delivery Orders",
                              style: TextStyle(color: Colors.black45)),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeliveryOrdersList()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : new Container(),
          group == "Admin"
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.65))),
                  child: ExpansionTile(
                    title: const Text("Marketplace",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    children: [
                      
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 0.65),
                                bottom: BorderSide(width: 0.65))),
                        child: ExpansionTile(
                          title: const Text('  App & Store Management',
                              style: TextStyle(color: Colors.black)),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Category Management",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryList()),
                                  );
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Banner Management",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BannerList()),
                                  );
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Zone Management",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ZoneList()),
                                  );
                                },
                              ),
                            ),
                          
                            
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                // top: BorderSide(width: 0.65),
                                bottom: BorderSide(width: 0.65))),
                        child: ExpansionTile(
                          title: const Text('  Seller & Distributor Management',
                              style: TextStyle(color: Colors.black)),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(width: 0.65),
                                      bottom: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Seller's List",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SellerList()),
                                  );
                                },
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border(bottom: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Distributor's List ",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DistributorList()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                // top: BorderSide(width: 0.65),
                                bottom: BorderSide(width: 0.65))),
                        child: ExpansionTile(
                          title: const Text('  Order Management',
                              style: TextStyle(color: Colors.black)),
                          children: [
                             
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                     top: BorderSide(width: 0.65),
                                    bottom: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Customer's List ",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuyerList()),
                                  );
                                },
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text("        Order Lists",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerOrdersList()),
                                  );
                                },
                              ),
                            ),
                            
                           
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                // top: BorderSide(width: 0.65),
                                bottom: BorderSide(width: 0.65))),
                        child: ExpansionTile(
                          title: const Text('  Product Management',
                              style: TextStyle(color: Colors.black)),
                          children: [
                             
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                     top: BorderSide(width: 0.65),
                                    )),
                              child: ListTile(
                                title: const Text("        Product's",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllProductsList()),
                                  );
                                },
                              ),
                            ),
                            
                            
                           
                          ],
                        ),
                      ),
                      Container(
                        // decoration: BoxDecoration(
                            // border: Border(
                            //     // top: BorderSide(width: 0.65),
                            //     bottom: BorderSide(width: 0.65))),
                        child: ExpansionTile(
                          title: const Text('  Subscription Management',
                              style: TextStyle(color: Colors.black)),
                          children: [
                             Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text(
                                    "        Subscribers List",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerSubscriptionList()),
                                  );
                                },
                              ),
                            ),
                           Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: 0.65))),
                              child: ListTile(
                                title: const Text(
                                    "        Subscribed Orders",
                                    style: TextStyle(color: Colors.black45)),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerSubscriptionOrdersList()),
                                  );
                                },
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : new Container(),
          Container(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0.65))),
            child: ListTile(
              title: Text("${IsLogin == true ? "Logout" : "Login"}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: IsLogin == true
                  ? () {
                      logout(context, number.toString());
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
