import 'dart:convert';

import 'package:dhurmaati/screens/customer-order-management/customer-order-details.dart';
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
import '../orders_screen.dart';
import '../seller_customer_orders/customer_order_details_screen.dart';

class CustomerOrdersList extends StatefulWidget {
  const CustomerOrdersList({Key? key}) : super(key: key);

  @override
  State<CustomerOrdersList> createState() => _CustomerOrdersListState();
}

class _CustomerOrdersListState extends State<CustomerOrdersList> {
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
    getDistributors(context, '');
    // }
    // dateinput.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  List orderList = [];
  List selectedList = [];
  Future getDetails(BuildContext context, String date) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = date == ''
        ? await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-all-orders'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
          )
        : await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-all-orders/')
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
        // selectedList = List.generate(message, (index) => false);
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
  int? _values;

  late List<DropdownMenuItem<int>> _menu;
   List<dynamic> categoryList = [];
  Future getDistributors(BuildContext context, String search) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-distributors'),
      // .replace(queryParameters: {'search': search}),
      // Uri.parse('${Constant.KEY_URL}/api/get-all-sellers/')
      //     .replace(queryParameters: {'search': search}),
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
        _values = message[0]["user_id"];
        print(categoryList);
      });
      _menu = List.generate(
        message.length,
        (i) => DropdownMenuItem(
          value: message[i]["user_id"],
          child: Text(
              "${message[i]["name"]} (${message[i]["assigned_deliveries"]} Deliveries)"),
        ),
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
   Future assignOrder(List order_id, int distributor_id) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.put(
      Uri.parse('${Constant.KEY_URL}/api/assign-distributor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body:
          jsonEncode({"distributor_id": distributor_id, "order_id": order_id}),
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
      // Navigator.pop(context);
      // setState(() {
      //   _zoneareaController.text = '';
      //   _zonenameController.text = '';
      // });
      // getDetails(context);
      Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerOrdersList()),
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


  List selectedItems = [];

  TextEditingController dateinput = TextEditingController();
  bool isSelectItem = false;
  Map<int, bool> selectedItem = {};
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
                        "  Customer Order's List ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                            // Map order = orderList[index];
                            final order = orderList[index];
                            selectedItem[index] = order[index] ?? false;
                            bool? isSelectedData = selectedItem[index];

                            return 
                                    GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            if (selectedItems.contains(order["order_id"])) {
                                              selectedItems.remove(order["order_id"]);
                                            } else {
                                              selectedItems.add(order["order_id"]);
                                            }
                                          });
                                          print(selectedItems);
                                        },
                                        child: Column(children: [
                                          Container(
                                              margin:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 30,
                                                      padding: const EdgeInsets
                                                              .symmetric(
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
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .white)),
                                                            Text(
                                                                '${order["order_type"]}  ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .white)),
                                                          ])),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                              child: Text(
                                                                  'Order Date: ${order["date"]}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                              child: Text(
                                                                  'Total Price : ₹${order["total"]}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                              child: Text(
                                                                  'Order Status : ${order["status"]}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                              child: Text(
                                                                  '${order["is_assigned"] ? "Order is assigned to a distributor" : "Order is not assigned yet"}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.5,
                                                              child: ListView
                                                                  .builder(
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: order[
                                                                        'cart_items']
                                                                    .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int ind) {
                                                                  final product =
                                                                      order['cart_items']
                                                                          [ind];
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            16.0,
                                                                        vertical:
                                                                            8.0),
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Image.network(
                                                                            product[
                                                                                "image_url"],
                                                                            height:
                                                                                100.0,
                                                                            width:
                                                                                100.0),
                                                                        SizedBox(
                                                                            width:
                                                                                16.0),
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Text(product['product_name'], style: TextStyle(fontSize: 18.0)),
                                                                              SizedBox(height: 8.0),
                                                                              Text('Qty: ${product['quantity']}', style: TextStyle(fontSize: 16.0)),
                                                                              SizedBox(height: 8.0),
                                                                              Text('Price: ₹${product['price']}', style: TextStyle(fontSize: 16.0)),
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
                                                        Column(children: [

                                                       
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .arrow_forward_ios),
                                                          onPressed: () {
                                                            var orders = [
                                                              order
                                                            ];
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CustomerOrderDetailsPage(
                                                                          orders)),
                                                            );
                                                          },
                                                        ),
                                                        selectedItems.length == 0 ? new Container():
                                                        Checkbox(value: selectedItems.contains(order["order_id"]) ? true : false, onChanged:(value){
                                                          setState(() {
                                            if (selectedItems.contains(order["order_id"])) {
                                              selectedItems.remove(order["order_id"]);
                                            } else {
                                              selectedItems.add(order["order_id"]);
                                            }
                                          });
                                          print(selectedItems);
                                                        } )
                                                         ],)
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(height: 1.0),
                                                ],
                                              ))
                                        ]));
                          },
                        ),
                         selectedItems.length != 0
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(color: Colors.white),
                      // width: MediaQuery.of(context).size.width - 40,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: new Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Distributor  ",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  // width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.red,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      borderRadius: BorderRadius.circular(20)
                                          .copyWith(
                                              topLeft: Radius.circular(0)),
                                      underline: Container(),
                                      items: _menu,
                                      value: _values,
                                      onChanged: (value) {
                                        // getDistributor(context, value!);
                                        setState(() {
                                          _values = value!;
                                          // showdistributor = true;
                                        });
                                        print(_values);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                  : new Container(),
                        selectedItems.length == 0
                      ? new Container()
                      : Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 193, 63, 41)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                            child: const Text(
                              'Assign Order',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            onPressed: () {
                              assignOrder(selectedItems, _values!);
                              // getDistributor(
                              //     context, widget.orders[0]["zone_id"]);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => VerifyOTP(_controller.text)));
                              // setState(() {
                              //   showzone = true;
                              //   // addUser(context, _controller.text);
                              // });
                            },
                          )),
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

  Widget _mainUI(bool isSelected, Map ourdata) {
    if (isSelectItem) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${ourdata['order_id']}'),
      );
    }
  }
}
