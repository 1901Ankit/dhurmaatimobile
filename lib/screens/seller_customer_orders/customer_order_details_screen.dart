import 'dart:convert';

import 'package:dhurmaati/screens/customer-order-management/customer_order_list.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../../widget/appBarDrawer.dart';
import '../../widget/appBarTitle.dart';
import '../../widget/bottomnavigation.dart';
import '../cart_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import '../wishlist_screen.dart';

class CustomerOrdersDetailsPage extends StatefulWidget {
  final List orders;

  CustomerOrdersDetailsPage(this.orders);

  @override
  State<CustomerOrdersDetailsPage> createState() =>
      _CustomerOrdersDetailsPageState();
}

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class _CustomerOrdersDetailsPageState extends State<CustomerOrdersDetailsPage> {
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

  Future addZone(int order_id, int distributor_id) async {
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
                          children: [
                            Image.network(
                              '${order["image_url"]}',
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${order["product_name"]}'),
                                Text('Quantity: ${order["quantity"]}'),
                                Text('Price: ₹${order["price"]}'),
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
                            'Address: ${widget.orders[0]["users"]["address1"]}'),
                        Text('City: ${widget.orders[0]["users"]["city"]}'),
                        Text('State: ${widget.orders[0]["users"]["state"]}'),
                        Text('Pin Code : ${widget.orders[0]["users"]["pin"]}'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.orders[0]["is_assigned"]
                  ? Center(
                      child: Text(
                        "The order is assigned to a Delivery Agent",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Center(
                      child: Text(
                        "The order is not assigned to a Delivery Agent yet.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          )),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }
}
