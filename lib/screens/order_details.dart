import 'dart:convert';
// import 'dart:html';

import 'package:dhurmaati/screens/customer-order-management/customer_order_list.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../../widget/appBarDrawer.dart';
import '../../widget/appBarTitle.dart';
import '../../widget/bottomnavigation.dart';

import 'cart_screen.dart';
import 'main_dashboard_page.dart';
import 'main_profile.dart';

class OrderDetailsPage extends StatefulWidget {
  final List orders;

  OrderDetailsPage(this.orders);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int _selectedScreenIndex = 0;

  late List _screens;
  int _value = 1;
  int? _values;

  @override
  initState() {
    _screens = [
      {"screen": DashBoard(), "title": "DashBoard"},
      {"screen": CartPage(), "title": "Cart"},
      {"screen": OrdersList(), "title": "Orders"},
      {"screen": MyProfile(), "title": "My Account"}
    ];
    getDetails(context);
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

  bool showzone = false;
  bool showdistributor = false;
  late List<DropdownMenuItem<int>> _menuItems;
  late List<DropdownMenuItem<int>> _menu;

  List<dynamic> zoneList = [];
  Future getDetails(BuildContext context) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-zones'),
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
      print(message);
      setState(() {
        zoneList = message;
        print(zoneList[0]);
      });

      _menuItems = List.generate(
        message.length,
        (i) => DropdownMenuItem(
          value: message[i]["zone_id"],
          child: Text("${message[i]["zone_name"]}"),
        ),
      );
      print(_menuItems);
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

  TextEditingController _cityController = TextEditingController();
  List distributorList = [];

  Future getDistributor(BuildContext context, int zone_id) async {
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
        showdistributor = true;
        distributorList = message;
        // print(distributorList);
        showdistributor = message.isEmpty ? false : true;
        _values = message[0]["user_id"];
      });
      _menu = List.generate(
        message.length,
        (i) => DropdownMenuItem(
          value: message[i]["user_id"],
          child: Text(
              "${message[i]["name"]} (${message[i]["assigned_deliveries"]} Deliveries)"),
        ),
      );
      print(_menu);
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

  Future addRating(
      int id, double rating, String comment, String Subject) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/add-rating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode({
        "product_id": id,
        "rating": rating,
        "comment": comment,
        "subject": Subject
      }),
    );
    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      print(message);
      setState(() {
        _cityController.text = "";
      });
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
        MaterialPageRoute(builder: (context) => OrdersList()),
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

        // prefManager.remove(Constant.KEY_LOGIN_TOKEN);
        // prefManager.remove(Constant.KEY_IS_LOGIN);
        // prefManager.remove(Constant.KEY_AVATAR_URL);
        // prefManager.remove(Constant.KEY_USER_GROUP);
        // prefManager.remove(Constant.KEY_USER_ID);
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

  String dropdownvalue = 'Quality';

  // List of items in our dropdown menu
  var items = [
    'Quality',
    'Price',
    'Service',
  ];
  double? _rating;
  IconData? _selectedIcon;
  @override
  Widget build(BuildContext context) {
    print(widget.orders[0]);
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
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "   Order items",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.orders[0]["cart_items"].length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = widget.orders[0]["cart_items"][index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Card(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              '${order["image_url"]}',
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Name: ${order["product_name"]}'),
                                          Text(
                                              'Quantity: ${order["quantity"]}'),
                                          Text('Price: ₹${order["price"]}'),
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(context,
                                                      order["product_id"]),
                                            );
                                          },
                                          child: Text("Rate "))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Details'),
                        SizedBox(height: 8.0),
                        Text('Name: ${widget.orders[0]["users"]["name"]}'),
                        Text(
                            'Contact Number: ${widget.orders[0]["users"]["contact_no"]}'),
                        Text(
                            'Address: ${widget.orders[0]["users"]["address1"]},'),
                        Text(
                            'Address: ${widget.orders[0]["users"]["address2"]}'),
                        Text('City: ${widget.orders[0]["users"]["city"]}'),
                        Text('State: ${widget.orders[0]["users"]["state"]}'),
                        Text('Pin Code : ${widget.orders[0]["users"]["pin"]}'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
                 Container(
                   margin: EdgeInsets.symmetric( horizontal: 10),
                   child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [

                        Text("Want to see the order status:    ",style: TextStyle(fontSize:16),),
                        InkWell(
                            child: Text(
                          'View Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        )),
                      ],
                    )),
                 ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 60,
                  width: 423,
                  // color: Color.fromARGB(255, 193, 63, 41),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ))),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PackageDeliveryTrackingPage()));
                    },
                    child: const Text('View Status',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              ),

              // widget.orders[0]["is_assigned"]
              //     ? Center(
              //         child: Text(
              //           "The order is assigned to a Delivery Agent",
              //           style: TextStyle(
              //               fontSize: 20, fontWeight: FontWeight.bold),
              //         ),
              //       )
              //     : Center(
              //         child: Text(
              //           "The order is not assigned to a Delivery Agent yet.",
              //           style: TextStyle(
              //               fontSize: 20, fontWeight: FontWeight.bold),
              //         ),
              //       ),
            ],
          )),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }

  Widget _buildPopupDialog(BuildContext context, int id) {
    return new AlertDialog(
      title: const Text('Rate This Product'),
      content: new Container(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subject:"),
                    DropdownButton(
                      value: dropdownvalue,
                      hint: Text("Select"),
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("Rate"),
                  Container(
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RatingBar.builder(
                      initialRating: _rating ?? 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, _) => Icon(
                        _selectedIcon ?? Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _cityController,
                  // Use secure text for passwords.
                  decoration: new InputDecoration(
                      hintText: 'Comment', labelText: 'Comment!!!'),
                  // validator: this._validatePassword,
                  // onSaved: (String value) {
                  //   this._data.password = value;
                  // }
                ),
              ),
           
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 60,
                  width: 423,
                  // color: Color.fromARGB(255, 193, 63, 41),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ))),
                    onPressed: () async {
                      addRating(
                          id, _rating!, _cityController.text, dropdownvalue);
                    },
                    child: const Text('Submit',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              )
            ],
          ),
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
    );
  }
}
