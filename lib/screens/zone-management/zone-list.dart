import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
import '../delivery-agent-management/delivery-agent-list.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import '../wishlist_screen.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

class ZoneList extends StatefulWidget {
  const ZoneList({Key? key}) : super(key: key);

  @override
  State<ZoneList> createState() => _ZoneListState();
}

class _ZoneListState extends State<ZoneList> {
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

  Future addZone(String zone_name, String zone_area) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/add-zone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode({"zone_name": zone_name, "zone_area": zone_area}),
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
      Navigator.pop(context);
      setState(() {
        _zoneareaController.text = '';
        _zonenameController.text = '';
      });
      getDetails(context);

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

  Future editZone(String zone_name, String zone_area, int zone_id) async {
    print(zone_area);
    print(zone_name);
    print(zone_id);
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.put(
      Uri.parse('${Constant.KEY_URL}/api/edit-zone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode(
          {"zone_name": zone_name, "zone_area": zone_area, "zone_id": zone_id}),
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
      Navigator.pop(context);
      setState(() {
        _zoneareaController.text = '';
        _zonenameController.text = '';
      });
      getDetails(context);

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

  Future deleteZone(BuildContext context, int zone_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response =
        await http.delete(Uri.parse('${Constant.KEY_URL}/api/delete-zone'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"zone_id": zone_id}));

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

  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  final TextEditingController _zonenameController = TextEditingController();
  final TextEditingController _zoneareaController = TextEditingController();
  final TextEditingController _editzonenameController = TextEditingController();
  final TextEditingController _editzoneareaController = TextEditingController();
  showaddzone(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Add Zone'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _zonenameController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                          ),
                          prefixIconColor: myFocusNode.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? Color.fromARGB(255, 193, 63, 41)
                                  : Colors.black),
                          labelText: 'Zone Name',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _zoneareaController,
                        focusNode: myFocusNode2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                          ),
                          prefixIconColor: myFocusNode2.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelText: 'Zone Area',
                          labelStyle: TextStyle(
                              color: myFocusNode2.hasFocus
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
              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    // your code
                    addZone(_zonenameController.text, _zoneareaController.text);
                  }),
              RaisedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // your code
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  showdeletezone(BuildContext context, int zone_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          height: 300,
          child: AlertDialog(
            title: Text(
              'Delete Zone',
              style: TextStyle(fontFamily: 'Poppins-Bold'),
            ),
            content: Text(
              'Are you sure you want to delete this Zone ?',
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
                  deleteZone(context, zone_id);
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

  showeditAlert(BuildContext context, int comment_id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Edit Zone'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _editzonenameController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                          ),
                          prefixIconColor: myFocusNode.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? Color.fromARGB(255, 193, 63, 41)
                                  : Colors.black),
                          labelText: 'Zone Name',
                          // icon: Icon(
                          //   Icons.location_on,
                          //   color:,
                          // ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _editzoneareaController,
                        focusNode: myFocusNode2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                          ),
                          prefixIconColor: myFocusNode2.hasFocus
                              ? Color.fromARGB(255, 193, 63, 41)
                              : Colors.black,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 63, 41)),
                          ),
                          labelText: 'Zone Area',
                          labelStyle: TextStyle(
                              color: myFocusNode2.hasFocus
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
              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    // your code
                    editZone(_editzonenameController.text,
                        _editzoneareaController.text, comment_id);
                  }),
              RaisedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // your code
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

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
        body: Container(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "  Zone's List",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    height: 40,
                    // width: 80,
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 16,
                      ),
                      label: Text(
                        "Add",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () async {
                        showaddzone(context);
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1.5, color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )),
              ]),
              SizedBox(
                height: 10,
              ),
              zoneList.isEmpty
                  ? Container(
                      height: 350,
                      child: Center(
                          child: Text(
                        "No Zone Available ",
                        style: TextStyle(fontSize: 18),
                      )))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: zoneList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 30,
                                        ),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem<int>(
                                              value: 0,
                                              child: Text("Edit Zone"),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: Text("delete Zone"),
                                            )
                                          ];
                                        },
                                        onSelected: (value) {
                                          if (value == 0) {
                                            showeditAlert(context,
                                                zoneList[index]["zone_id"]);
                                            setState(() {
                                              _editzonenameController.text =
                                                  zoneList[index]["zone_name"];
                                              _editzoneareaController.text =
                                                  zoneList[index]["zone_area"];
                                            });
                                          } else if (value == 1) {
                                            showdeletezone(context,
                                                zoneList[index]["zone_id"]);
                                          }
                                        }),
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 40,
                                      color: Color.fromARGB(255, 193, 63, 41),
                                    ),
                                  ],
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text('${zoneList[index]["zone_name"]}'),
                                ],
                              ),
                              subtitle: Text('${zoneList[index]["zone_area"]}'),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeliveryAgentList(
                                            zoneList[index]["zone_name"],
                                            zoneList[index]["zone_id"])),
                                  );
                                },
                              ),
                            ));
                      },
                    ),
            ]),
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
