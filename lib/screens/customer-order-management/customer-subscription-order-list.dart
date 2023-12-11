import 'dart:convert';

import 'package:dhurmaati/screens/customer-order-management/customer-order-details.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../cart_screen.dart';
import '../login_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import '../seller_customer_orders/customer_order_details_screen.dart';

class CustomerSubscriptionOrdersList extends StatefulWidget {
  const CustomerSubscriptionOrdersList({Key? key}) : super(key: key);

  @override
  State<CustomerSubscriptionOrdersList> createState() =>
      _CustomerSubscriptionOrdersListState();
}

class _CustomerSubscriptionOrdersListState
    extends State<CustomerSubscriptionOrdersList> {
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
    getDetails(context, '');
    // }
    // dateinput.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  List orderList = [];
  Future getDetails(BuildContext context, String date) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = date == ''
        ? await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-all-subscription-orders'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
          )
        : await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-all-subscription-orders/')
                .replace(queryParameters: {'date': date}),
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
        orderList = message;
        print(orderList);
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

  TextEditingController dateinput = TextEditingController();

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
        body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 1),
                () {
                  getDetails(context, '');
                  setState(() {
                    dateinput.text = '';
                  });
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "  Customer subscription Orders",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                          child: TextField(
                        controller:
                            dateinput, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateinput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                            getDetails(context, formattedDate);
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  orderList.isEmpty
                      ? Center(
                          child: Text("No orders Available"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: orderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final order = orderList[index];
                            return GestureDetector(
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.black),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '  Order #${order["order_id"]}',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white)),
                                                  Text(
                                                      '${order["order_type"]}  ',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white)),
                                                ])),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    child: Text(
                                                        'Order Date: ${order["date"]}',
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    child: Text(
                                                        'Total Price : ₹${order["total"]}',
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    child: Text(
                                                        'Order Status : ${order["status"]}',
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    child: Text(
                                                        '${order["is_assigned"] ? "Order is assigned to a distributor" : "Order is not assigned yet"}',
                                                        style: TextStyle(
                                                            fontSize: 16.0)),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    child: ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          order['cart_items']
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int ind) {
                                                        final product =
                                                            order['cart_items']
                                                                [ind];
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Image.network(
                                                                  product[
                                                                      "image_url"],
                                                                  height: 100.0,
                                                                  width: 100.0),
                                                              SizedBox(
                                                                  width: 16.0),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        product[
                                                                            'product_name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0)),
                                                                    SizedBox(
                                                                        height:
                                                                            8.0),
                                                                    Text(
                                                                        'Qty: ${product['quantity']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.0)),
                                                                    SizedBox(
                                                                        height:
                                                                            8.0),
                                                                    Text(
                                                                        'Price: ₹${product['price']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.0)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                onPressed: () {
                                                  var orders = [order];
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomerOrdersDetailsPage(
                                                                orders)),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(height: 1.0),
                                      ],
                                    )));
                          },
                        ),
                ],
              )),
            )),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
        // ),
      ),
    );
  }
}
