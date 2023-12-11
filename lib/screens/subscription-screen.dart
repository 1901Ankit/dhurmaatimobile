import 'dart:convert';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:csc_picker/csc_picker.dart';

import 'dart:io';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/thank_you_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/cartModel.dart';
import '../model/subscriptionModel.dart';

class SubscriptionPage extends StatefulWidget {
  // final List data;
  // SubscriptionPage(this.data);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>  with SingleTickerProviderStateMixin{
  // bool isLoggedIn = false;
  bool isVerify = false;
  bool isNewUser = false;
  int _n = 0;
  String? uid;

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  int _selectedScreenIndex = 0;
  final TextEditingController _numcontroller = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();

  late List _screens;
late int totalTimeInSeconds;
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
    getZones(context);
    // }

    
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);

  }

  List<dynamic> object = [];
  String? group;

  bool? isLoggedIn;
  Future getDetails(BuildContext context) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);
    setState(() {
      group = prefManager.getString(Constant.KEY_USER_GROUP);

      isLoggedIn = prefManager.getBool(Constant.KEY_IS_LOGIN);
      print(group);
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
      // print(res);
      var respon = res["response"];
      var message = respon["message"];
      setState(() {
        object = [message];
        print(object[0]);
        isNewUser = false;
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
      // setState(() {
      //   isNewUser = true;
      // });
      throw Exception('Failed to create album.');
    }
  }
final int time = 30;
  late AnimationController _controller;
  DateTimeRange? _selectedDateRange;

  // This function will be triggered when the floating button is pressed
  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now().add(Duration(days: 1)),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print(result);
      setState(() {
        _selectedDateRange = result;
      });
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

  late List<DropdownMenuItem<int>> _menuItems;
  int _value = 1;

  TextEditingController _nameController = TextEditingController();
  // TextEditingController _professionController = TextEditingController();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? countryValue;
  String? stateValue;
  String? cityValue;
   bool _hideResendButton = false;
  Future CompleteProfile(
      BuildContext context,
      // String login_token,
      File? imagefile,
      String name,
      String pin,
      String address,
      String address2,
      String city,
      String state) async {
    final prefManager = await SharedPreferences.getInstance();

    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    String? group = prefManager.getString(Constant.KEY_USER_GROUP);
    print(group);
    Map<String, String> headers = {'Authorization': 'Bearer $login_token'};
    var req = http.MultipartRequest(
        'POST', Uri.parse('${Constant.KEY_URL}/api/add-details'));
    req.fields['name'] = name.toString();
    req.fields['pin'] = pin;

    req.fields['city'] = city.toString();
    req.fields['state'] = state.toString();
    req.fields['address1'] = address.toString();
    req.fields['address2'] = address2.toString();
    req.headers.addAll(headers);
    // print(profession);
    if (imagefile != null) {
      req.files.add(http.MultipartFile.fromBytes(
          'file', File(imagefile.path).readAsBytesSync(),
          filename: imagefile.path));
    }
    var respo = await req.send();
    if (respo.statusCode == 200) {
      // var res = respo.body;
      var res = await http.Response.fromStream(respo);
      final result = jsonDecode(res.body);
      var rest = result["response"];
      var message1 = rest["message"];
      // print(data);
      print(message1);
      print(res);
      print(result);
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => new DashBoard()),
      //     (route) => false);
      Fluttertoast.showToast(
        msg: "$message1",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      getDetails(context);
    } else if (respo.statusCode > 200) {
      var res = await http.Response.fromStream(respo);
      var data = jsonDecode(res.body);

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

  // var login_token;
  Future addUser(BuildContext context, String title) async {
    print('${Constant.KEY_URL}');
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': title,
      }),
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];
      print(data);
      print(message1);

      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => VerifyOTP(title)));
      // return Album.fromJson(jsonDecode(response.body));
      Fluttertoast.showToast(
        msg: "$message1",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // _verifyPhone();
      setState(() {
        isVerify = !isVerify;
        // addUser(context, _controller.text);
      });
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
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
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
    // }
  }

  String dropdownvalue = 'DAILY';
  // DateTimeRange? _selectedDateRange;
  DateRangePickerController _datePickerController = DateRangePickerController();
  // // This function will be triggered when the floating button is pressed
  // void _show() async {
  //   final DateTimeRange? result = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(2022, 1, 1),
  //     lastDate: DateTime(2030, 12, 31),
  //     currentDate: DateTime.now(),
  //     saveText: 'Done',
  //   );

  //   if (result != null) {
  //     // Rebuild the UI
  //     print(result.start.toString());
  //     setState(() {
  //       _selectedDateRange = result;
  //     });
  //   }
  // }

  // List of items in our dropdown menu
  var items = ["DAILY", "WEEKLY", "RANGE"];
  var login_token;
  File? imagefile;
  Future verifyUID(BuildContext context, String number, String uid) async {
    final prefManager = await SharedPreferences.getInstance();
    print(uid);
    print(number);
    String? token = prefManager.getString(Constant.KEY_DEVICE_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'phone_number': number, 'otp': uid,'device_token':token}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];

      login_token = message1["login_token"];
      var group = message1["group_name"];
      var user_id = message1["user_id"];
      var user_data = message1["userData"];
      setState(() {
        _addressController.text = user_data["address1"] == null ? "":user_data["address1"];
        _address2Controller.text = user_data["address2"] == null ? "":user_data["address2"];
        _pinController.text = user_data["pin"] == null ? "":user_data["pin"].toString();
        cityValue = user_data["city"] == null ? "":user_data["city"];
        stateValue = user_data["state"] == null ? "":user_data["state"];

        _nameController.text =user_data["name"] == null ? "":user_data["name"];

      });
      prefManager.setString(Constant.KEY_LOGIN_TOKEN, login_token);
      prefManager.setBool(Constant.KEY_IS_LOGIN, true);
      prefManager.setString(Constant.KEY_USER_GROUP, group);
      prefManager.setInt(Constant.KEY_USER_ID, user_id);
      // String? tk = prefManager.getString(Constant.KEY_LOGIN_TOKEN);

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => DashBoard()),
      //     (route) => false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: 380,
                child: SingleChildScrollView(
                  child: Stack(
                    fit: StackFit.loose,
                    // overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Enter Shipping Address Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                                  Padding(
                                padding: EdgeInsets.only(
                                   right: 25.0, top: 10.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                // Use secure text for passwords.
                                decoration: new InputDecoration(
                                    hintText: 'Full Name',
                                    ),
                                // validator: this._validatePassword,
                                // onSaved: (String value) {
                                //   this._data.password = value;
                                // }
                                controller: _nameController,
                              ),
                            ),
                             Padding(
                                padding: EdgeInsets.only(
                                     right: 25.0, top: 10.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _addressController,
                                // Use secure text for passwords.
                                decoration: new InputDecoration(
                                    hintText: 'House No/Flat No',
                                    ),
                                // validator: this._validatePassword,
                                // onSaved: (String value) {
                                //   this._data.password = value;
                                // }
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _address2Controller,
                                // Use secure text for passwords.
                                decoration: new InputDecoration(
                                    hintText: 'Street/Locality',
                                   ),
                                // validator: this._validatePassword,
                                // onSaved: (String value) {
                                //   this._data.password = value;
                                // }
                              ),
                            ),
                             Padding(
                                padding: EdgeInsets.only(
                                    right: 25.0, top: 10.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Country',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                             Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: CSCPicker(
                                defaultCountry: CscCountry.India,
                                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                showStates: true,
                                layout: Layout.vertical,

                                currentCity: cityValue,
                                currentState: stateValue,
                                currentCountry: 'India',
                                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                
                                countrySearchPlaceholder: "Search Your Country",
                                stateSearchPlaceholder: "Search Your State",
                                citySearchPlaceholder: "Search Your Country",
                                countryDropdownLabel: "Enter Your Country",
                                stateDropdownLabel: "Enter Your State",
                                cityDropdownLabel: "Enter Your City",
  //                         

                                ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                flagState: CountryFlag.DISABLE,

                                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                dropdownDecoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  // .all(color: Colors.grey.shade300, width: 1)
                                ),

                                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                disabledDropdownDecoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.grey.shade300,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                ),

                                ///selected item style [OPTIONAL PARAMETER]
                                selectedItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),

                                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                dropdownHeadingStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),

                                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),

                                ///Dialog box radius [OPTIONAL PARAMETER]
                                dropdownDialogRadius: 10.0,

                                ///Search bar radius [OPTIONAL PARAMETER]
                                searchBarRadius: 10.0,

                                ///triggers once country selected in dropdown
                                onCountryChanged: (value) {
                                  setState(() {
                                    ///store value in country variable
                                    countryValue = value;
                                  });
                                },

                                ///triggers once state selected in dropdown
                                onStateChanged: (value) {
                                  setState(() {
                                    ///store value in state variable
                                    stateValue = value;
                                  });
                                },

                                ///triggers once city selected in dropdown
                                onCityChanged: (value) {
                                  setState(() {
                                    ///store value in city variable
                                    cityValue = value;
                                  });
                                },
                              ),
                            ),

                            // Padding(
                            //   padding: EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: _stateController,

                            //     decoration: new InputDecoration(
                            //         hintText: 'State',
                            //         labelText: 'Enter Your State'),
                            //     // validator: this._validatePassword,
                            //     // onSaved: (String value) {
                            //     //   this._data.password = value;
                            //     // }
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.all(8.0),
                            //   child: TextFormField(
                            //     controller: _cityController,
                            //     // Use secure text for passwords.
                            //     decoration: new InputDecoration(
                            //         hintText: 'City',
                            //         labelText: 'Enter Your City'),
                            //     // validator: this._validatePassword,
                            //     // onSaved: (String value) {
                            //     //   this._data.password = value;
                            //     // }
                            //   ),
                            // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 25.0, top: 10.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Pin Code',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                                // Use secure text for passwords.
                                decoration: new InputDecoration(
                                    hintText: 'Pin Code',
                                   ),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(255, 193, 63, 41)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ))),
                                  onPressed: () async {
                                    CompleteProfile(
                                        context,
                                        imagefile,
                                        _nameController.text,
                                        _pinController.text,
                                        _addressController.text,
                                        _address2Controller.text,
                                        cityValue!,
                                        stateValue!
                                        // _cityController.text,
                                        // _stateController.text
                                        );
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
                    ],
                  ),
                ),
              ),
            );
          });
      setState(() {
        isVerify = !isVerify;
        // isNewUser = !isNewUser;
        // addUser(context, _controller.text);
      });
      Fluttertoast.showToast(
        msg: "Successfully Logged In",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => CartPage()),
      // );
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

  Future createSubscription(
      BuildContext context,
      String payment,
      List items,
      double cartvalue,
      int zone_id,
      String type,
      String startdate,
      String enddate,
      String slot) async {
    print(zone_id);
    final prefManager = await SharedPreferences.getInstance();

    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/add-subscription'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode({
        'total': cartvalue,
        'subscription_details': items[0],
        "slot": slot,
        "zone_id": zone_id,
        "type": type,
        "start_date": startdate,
        "end_date": enddate
      }),
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];
      print(data);
      print(message1);

      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => VerifyOTP(title)));
      // return Album.fromJson(jsonDecode(response.body));
      Fluttertoast.showToast(
        msg: "$message1",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // _verifyPhone();
      // setState(() {
      //   isVerify = !isVerify;
      //   // addUser(context, _controller.text);
      // });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ThankYouPage()),
          (route) => false);
      ScopedModel.of<SubscriptionModel>(context, rebuildOnChange: true)
          .clearCart();
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
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
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
    // }
  }

  bool isZone = true;
////////////////////////////////////////////////
  List<dynamic> zoneList = [];
  Future getZones(BuildContext context) async {
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
        isZone = false;
        zoneList = message;
        _menuItems = List.generate(
          message.length,
          (i) => DropdownMenuItem(
            value: message[i]["zone_id"],
            child: Text("${message[i]["zone_name"]}"),
          ),
        );
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

////////////////////////////////////////////////

  String? _verificationCode;
  String radioButtonItem = 'MOR';
  int id = 1;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Constant.BackGround_Image), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 253, 250, 219),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Subscribe".toUpperCase(),
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          leading: const BackButton(
            color: Colors.black,
            // onPressed:() { Navigator.pop(context, true); }, // <-- SEE HERE
          ),
        ),
        body: ScopedModel.of<SubscriptionModel>(context, rebuildOnChange: true)
                    .cart
                    .length ==
                0
            ? Center(
                child: Text("Nothing in subscription cart"),
              )
            : Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text(
                      //   "Subscribe".toUpperCase(),
                      //   style: TextStyle(
                      //       fontSize: 30, fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      isLoggedIn == true
                          ? object.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Delivery To:",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${object[0]["name"]}"
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${object[0]["address1"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            "${object[0]["address2"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            "${object[0]["state"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            "${object[0]["city"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            "Pin Code :${object[0]["pin"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${object[0]["contact_no"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45),
                                          ),
                                        ]),
                                  ],
                                )
                          : new Container(),
                      Divider(
                        height: 20,
                        thickness: 0.75,
                        endIndent: 0,
                        color: Colors.black45,
                      ),
                      ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ScopedModel.of<SubscriptionModel>(context,
                                  rebuildOnChange: true)
                              .total,
                          itemBuilder: ((context, index) {
                            return ScopedModelDescendant<SubscriptionModel>(
                                builder: (context, child, model) {
                              return Column(
                                children: [
                                  Row(children: [
                                    Container(
                                      height: 120,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  model.cart[index].imgUrl),
                                              fit: BoxFit.fill)),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "    ${model.cart[index].title}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "    Pure",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "    ₹ ${model.cart[index].price}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 270,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 100,
                                                alignment: Alignment.center,
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              193,
                                                              63,
                                                              41)),
                                                      child: new IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        splashColor:
                                                            Colors.transparent,
                                                        onPressed: () {
                                                          model.updateProduct(
                                                              model.cart[index],
                                                              model.cart[index]
                                                                      .qty -
                                                                  1);
                                                          // model.removeProduct(model.cart[index]);
                                                        },
                                                        icon: new Icon(
                                                          Icons.remove,
                                                          size: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    new Text(
                                                        model.cart[index].qty
                                                            .toString(),
                                                        style: new TextStyle(
                                                            fontSize: 20.0)),
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              193,
                                                              63,
                                                              41)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: new IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            model.updateProduct(
                                                                model.cart[
                                                                    index],
                                                                model.cart[index]
                                                                        .qty +
                                                                    1);
                                                            // model.removeProduct(model.cart[index]);
                                                          },
                                                          icon: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 12,
                                                          ),
                                                          // backgroundColor: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            width: 300,
                                                            height: 300,
                                                            child: AlertDialog(
                                                              title: Text(
                                                                'Remove Product',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins-Bold'),
                                                              ),
                                                              content: Text(
                                                                'Are you sure you want to remove product from the cart',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              ),
                                                              actions: [
                                                                FlatButton(
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'CANCEL',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                    ),
                                                                  ),
                                                                ),
                                                                FlatButton(
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  onPressed:
                                                                      () {
                                                                    model.removeProduct(
                                                                        model.cart[
                                                                            index]);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'YES',
                                                                    style:
                                                                        TextStyle(
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
                                                    },
                                                    icon: Icon(Icons.close)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                  Divider(
                                    height: 20,
                                    thickness: 1,
                                    endIndent: 0,
                                    color: Colors.black45,
                                  ),
                                ],
                              );
                            });
                          })),
                      // IconButton(
                      //   onPressed: _show,
                      //   icon: Icon(Icons.date_range),
                      // ),
                      // _selectedDateRange == null
                      //     ? const Center(
                      //         child:
                      //             Text('Press the button to show the picker'),
                      //       )
                      //     : Padding(
                      //         padding: const EdgeInsets.all(30),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             // Start date
                      //             Text(
                      //               "Start date: ${_selectedDateRange?.start.toString().split(' ')[0]}",
                      //               style: const TextStyle(
                      //                   fontSize: 24, color: Colors.blue),
                      //             ),
                      //             const SizedBox(
                      //               height: 20,
                      //             ),
                      //             // End date
                      //             Text(
                      //                 "End date: ${_selectedDateRange?.end.toString().split(' ')[0]}",
                      //                 style: const TextStyle(
                      //                     fontSize: 24, color: Colors.red))
                      //           ],
                      //         ),
                      //       ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: new Row(
                          // mainAxisAlignment: MainAxisAlignment.c,
                          children: <Widget>[
                            Text(
                              'Delivery Slot',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Radio(
                              value: 1,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green.shade400),
                              groupValue: id,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'MOR';
                                  id = 1;
                                });
                              },
                            ),
                            Text(
                              'Morning',
                              style: new TextStyle(fontSize: 17.0),
                            ),
                            Radio(
                              value: 2,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green.shade400),
                              groupValue: id,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'EVE';
                                  id = 2;
                                });
                              },
                            ),
                            Text(
                              'Evening',
                              style: new TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subscription Type:",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                      // SfDateRangePicker(
                      //   view: DateRangePickerView.month,
                      //   monthViewSettings:
                      //       DateRangePickerMonthViewSettings(firstDayOfWeek: 6),
                      //   selectionMode: DateRangePickerSelectionMode.multiRange,

                      //   // initialDisplayDate:
                      //   // DateTime.now().add(Duration(days: 1)),
                      //   //onSelectionChanged: _onSelectionChanged,
                      //   showActionButtons: true,
                      //   enablePastDates: false,
                      //   controller: _datePickerController,
                      //   onSubmit: (val) {
                      //     print(val);
                      //     // print(val.startDate);
                      //     // print(val.endDate);
                      //     print(_datePickerController.selectedRanges);
                      //   },
                      //   onCancel: () {
                      //     _datePickerController.selectedRanges = null;
                      //   },
                      // ),
                      dropdownvalue == "RANGE"
                          ? Row(
                              children: [
                                InkWell(
                                  // onTap: _show,
                                  child: Text(
                                    _selectedDateRange == null
                                        ? "Select Date"
                                        : "Change Date",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  // iconSize: 100,
                                  icon: const Icon(Icons.date_range),
                                  // the method which is called
                                  // when button is pressed
                                  onPressed: _show,
                                ),
                              ],
                            )
                          : new Container(),
                      _selectedDateRange == null
                          ? new Container()
                          : Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Text(
                                      maxLines: 2,
                                      'Your Subscription starts on ${_selectedDateRange?.start.toString().split(' ')[0]} and ends on ${_selectedDateRange?.end.toString().split(' ')[0]}'),
                                )
                              ],
                            ),
                      isZone
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: new Row(
                                // mainAxisAlignment: MainAxisAlignment.c,
                                children: <Widget>[
                                  Text(
                                    'Select Delivery Zone:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        DropdownButton<int>(
                                          underline: Container(),
                                          items: _menuItems,
                                          value: _value,
                                          onChanged: (value) =>
                                              setState(() => _value = value!),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  // Radio(
                                  //   value: 1,
                                  //   fillColor: MaterialStateColor.resolveWith(
                                  //       (states) => Colors.green.shade400),
                                  //   groupValue: id,
                                  //   onChanged: (val) {
                                  //     setState(() {
                                  //       radioButtonItem = 'MOR';
                                  //       id = 1;
                                  //     });
                                  //   },
                                  // ),
                                  // Text(
                                  //   'Morning',
                                  //   style: new TextStyle(fontSize: 17.0),
                                  // ),
                                  // Radio(
                                  //   value: 2,
                                  //   fillColor: MaterialStateColor.resolveWith(
                                  //       (states) => Colors.green.shade400),
                                  //   groupValue: id,
                                  //   onChanged: (val) {
                                  //     setState(() {
                                  //       radioButtonItem = 'EVE';
                                  //       id = 2;
                                  //     });
                                  //   },
                                  // ),
                                  // Text(
                                  //   'Evening',
                                  //   style: new TextStyle(
                                  //     fontSize: 17.0,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Price Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "₹" +
                                ScopedModel.of<SubscriptionModel>(context,
                                        rebuildOnChange: true)
                                    .totalCartValue
                                    .toString() +
                                "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Method",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Pay On Delivery",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style:
                                TextStyle(fontSize: 24, color: Colors.black45),
                          ),
                          Text(
                            "₹" +
                                ScopedModel.of<SubscriptionModel>(context,
                                        rebuildOnChange: true)
                                    .totalCartValue
                                    .toString() +
                                "",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isNewUser != true
                          ? new Container()
                          : Text(
                              "Please Loggin In, Before making the Payment",
                              style: TextStyle(fontSize: 14),
                            ),
                      isNewUser != true
                          ? new Container()
                          : SizedBox(
                              height: 20,
                            ),
                      isNewUser != true
                          ? new Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  isVerify
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            // left: 30,
                                            // right: 30,
                                          ),
                                          // child: SizedBox(

                                          child: TextField(
                                            keyboardType: TextInputType.number,

                                            // focusNode: mFocusNodeOTP,
                                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            maxLength: 6,
                                            style: TextStyle(
                                              // context: context,
                                              color: Colors.black,
                                              // fontSizeDelta: 3,
                                              // fontWeightDelta: -1
                                            ),
                                            controller: _pinPutController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              isDense: true, // Added this
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              // contentPadding: EdgeInsets.only(bottom: 13, left: 3),
                                              counterText: "",
                                              // focusedBorder: UnderlineInputBorder(),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              hintText: "Enter OTP",
                                              filled: true,
                                              // fillColor: Colors.white,
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            // ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText: "Enter Phone Number",
                                                prefixIcon: Icon(
                                                  Icons.tablet_android_sharp,
                                                  color: Colors.green,
                                                ),
                                                suffixIcon: Icon(
                                                  Icons
                                                      .keyboard_double_arrow_right,
                                                  color: Colors.green,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                )),
                                            keyboardType: TextInputType.number,
                                            controller: _numcontroller,
                                            cursorColor: Colors.green,
                                          ),
                                        ),
                                          isVerify
                                      ? Container(
                                          height: 30,
                                          alignment: Alignment.center,
                                          child: _hideResendButton
                                              ? InkWell(
                                                  child: Text(
                                                    "Resend OTP",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // context: context,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 15,
                                                      // fontSizeDelta: 1,
                                                      // fontWeightDelta: 0
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    addUser(context,
                                                    _numcontroller.text);
                                                  },
                                                )
                                              : OtpTimer(_controller, 45.0,
                                                  Colors.amber),
                                        )
                                      : new Container(),
                                  Container(
                                      height: 60,
                                      width: 380,
                                      // padding:
                                      // const EdgeInsets.fromLTRB(100, 0, 100, 0),
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromARGB(
                                                        255, 193, 63, 41)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ))),
                                        child: Container(
                                          child: Text(
                                            isVerify
                                                ? "Verify OTP"
                                                : 'Send OTP',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        onPressed:
                                            // () {
                                            // Navigator.of(context).push(
                                            // MaterialPageRoute(
                                            // builder: (context) =>
                                            // VerifyOTP(_controller.text)));
                                            !isVerify
                                                ? () {
                                                    addUser(context,
                                                        _numcontroller.text);
                                                  }
                                                : () async {
                                                  verifyUID(
                                                              context,
                                                              _numcontroller
                                                                  .text,
                                                              _pinPutController.text);
                                                    // try {
                                                    //   await FirebaseAuth
                                                    //       .instance
                                                    //       .signInWithCredential(
                                                    //           PhoneAuthProvider.credential(
                                                    //               verificationId:
                                                    //                   _verificationCode!,
                                                    //               smsCode:
                                                    //                   _pinPutController
                                                    //                       .text
                                                    //                       .toString()))
                                                    //       .then((value) async {
                                                    //     if (value.user !=
                                                    //         null) {
                                                    //       // print("<<<<<<<<<<<<<<<<<<<<<<<<");
                                                    //       // print(value.user!.uid);
                                                    //       String uids =
                                                    //           value.user!.uid;
                                                    //       setState(() {
                                                    //         uid =
                                                    //             value.user!.uid;
                                                    //       });
                                                    //       verifyUID(
                                                    //           context,
                                                    //           _numcontroller
                                                    //               .text,
                                                    //           uids);
                                                    //     }
                                                    //   });
                                                    // } catch (e) {
                                                    //   print(e);
                                                    //   Fluttertoast.showToast(
                                                    //     msg: "$e",
                                                    //     toastLength:
                                                    //         Toast.LENGTH_SHORT,
                                                    //     timeInSecForIosWeb: 1,
                                                    //     backgroundColor:
                                                    //         Colors.green[400],
                                                    //     textColor: Colors.white,
                                                    //     fontSize: 16.0,
                                                    //   );
                                                    //   ScaffoldMessenger.of(
                                                    //           context)
                                                    //       .showSnackBar(SnackBar(
                                                    //           content: Text(e
                                                    //               .toString())));
                                                    // }
                                                    // };\
                                                  },
                                      )),
                                ]),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 60,
                        width: 440,
                        // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        // color: Color.fromARGB(255, 193, 63, 41),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 193, 63, 41)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                          onPressed: isLoggedIn != true
                              ? () async {
                                  setState(() {
                                    isNewUser = true;
                                  });
                                }
                              : () async {
                                  setState(() {
                                    isNewUser = false;
                                  });
                                  createSubscription(
                                      context,
                                      "COD",
                                      ScopedModel.of<SubscriptionModel>(context,
                                              rebuildOnChange: true)
                                          .cart,
                                      ScopedModel.of<SubscriptionModel>(context,
                                              rebuildOnChange: true)
                                          .totalCartValue,
                                      _value,
                                      dropdownvalue,
                                      _selectedDateRange == null
                                          ? ""
                                          : _selectedDateRange!.start
                                              .toString()
                                              .split(' ')[0],
                                      _selectedDateRange == null
                                          ? ""
                                          : _selectedDateRange!.end
                                              .toString()
                                              .split(' ')[0],
                                      radioButtonItem);
                                  print(ScopedModel.of<SubscriptionModel>(
                                          context,
                                          rebuildOnChange: true)
                                      .totalCartValue);
                                },
                          child: Text(
                              isLoggedIn == true ? 'Subscribe ▶' : 'Proceed ▶',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                )),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${_numcontroller.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
               String uids = value.user!.uid;
                            setState(() {
                              uid = value.user!.uid;
                            });
                            verifyUID(context, _numcontroller.text, uids);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => ChoiceScreen()),
              //     (route) => false);
              print("hello");
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green[400],
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}
class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration {
    Duration? duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return new Text(
          timerString,
          // style: AppStyle.textViewStyleNormalButton(
          //     context: context,
          //     color: timeColor,
          //     fontSizeDelta: 1,
          //     fontWeightDelta: 0),
        );
      },
    );
  }
}
