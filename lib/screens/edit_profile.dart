import 'dart:convert';
import 'dart:io';

import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_picker/csc_picker.dart';

import '../Constants/constants.dart';
import 'main_dashboard_page.dart';
import 'orders_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyEditProfile extends StatefulWidget {
  // const MyEditProfile({Key? key}) : super(key: key);
  final List details;
  MyEditProfile(this.details);

  @override
  State<MyEditProfile> createState() => _MyEditProfileState();
}

// _nameController.text,
//                   _pinController.text,
//                   _addressController.text,
//                   _address2Controller.text,
//                   _emailController.text,
//                   _phoneController.text,
//                   _cityController.text,
//                   _stateController.text,
Future CompleteProfile(
    BuildContext context,
    // String login_token,
    File? imagefile,
    String name,
    String pin,
    String address,
    String address2,
    String email,
    String number,
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
  req.fields['contact_no'] = number.toString();
  req.fields['email'] = email.toString();
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new DashBoard()),
        (route) => false);
    Fluttertoast.showToast(
      msg: "$message1",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
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

class _MyEditProfileState extends State<MyEditProfile>
    with SingleTickerProviderStateMixin {
  int _selectedScreenIndex = 3;

  late List _screens;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  // TextEditingController _professionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  // int _selectedScreenIndex = 1;
  // late List _screens;
  // SingleValueDropDownController _cnt = SingleValueDropDownController();
  // String radioButtonItem = 'M';

  // Group Value for Radio Button.
  int id = 1;

  File? imagefile;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  Future goImage() async {
    try {
      final imagefile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imagefile == null) return;

      final imageTemp = File(imagefile.path);

      setState(() => this.imagefile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    _screens = [
      {"screen": DashBoard(), "title": "DashBoard"},
      {"screen": CartPage(), "title": "Cart"},
      {"screen": OrdersList(), "title": "Orders"},
      {"screen": MyProfile(), "title": "My Account"}
    ];
    // getdata() {
    // getDashBoard(context);
    // getPosts(context);
    // getDetails(context);
    // }

    _nameController.text =
        '${widget.details[0]["name"] == null ? '' : widget.details[0]["name"]}';
    _phoneController.text =
        '${widget.details[0]["contact_no"] == null ? '' : widget.details[0]["contact_no"]}';
    _pinController.text =
        '${widget.details[0]["pin"] == null ? '' : widget.details[0]["pin"]}';
    _emailController.text =
        '${widget.details[0]["email"] == null ? '' : widget.details[0]["email"]}';
    _addressController.text =
        '${widget.details[0]["address1"] == null ? '' : widget.details[0]["address1"]}';
    _address2Controller.text =
        '${widget.details[0]["address2"] == null ? '' : widget.details[0]["address2"]}';
        cityValue =
      widget.details[0]["city"] == null ? null : widget.details[0]["city"];
    _cityController.text =
        '${widget.details[0]["city"] == null ? '' : widget.details[0]["city"]}';
        stateValue=  widget.details[0]["state"] == null ? null : widget.details[0]["state"];
    _stateController.text =
        '${widget.details[0]["state"] == null ? '' : widget.details[0]["state"]}';
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
          body: new Container(
            // color: Colors.white,
            // margin: EdgeInsets.only(bottom: 40),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 200.0,
                      // color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 40.0),
                            child: new Stack(fit: StackFit.loose, children: <
                                Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  imagefile != null
                                      ? Container(
                                          alignment: Alignment(0.0, 2.5),
                                          child: CircleAvatar(
                                            // backgroundColor: Colors.white,
                                            backgroundImage: FileImage(
                                                imagefile!,
                                                scale: 1.0),
                                            // child: Container(
                                            // child: Image.file(
                                            //   imagefile!,
                                            //   height: 100,
                                            //   width: 100,

                                            // ),
                                            // ),
                                            radius: 70.0,
                                          ))
                                      : Container(
                                          alignment: Alignment(0.0, 2.5),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                widget.details[0]["avatar"]),
                                            radius: 70.0,
                                          ),
                                        ),
                                  // Image.network(
                                  //     "${widget.details[0]["avatar"]}",
                                  //     width: 150,
                                  //     height: 150,
                                  //     fit: BoxFit.fill),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 100.0, right: 90.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 20.0,
                                        child: IconButton(
                                          icon: const Icon(Icons.camera_alt),
                                          color: Colors.white,
                                          onPressed: !_status
                                              ? () {
                                                  goImage();
                                                }
                                              : () {},
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      // color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status
                                            ? _getEditIcon()
                                            : new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
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
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Name",
                                        ),
                                        controller: _nameController,
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email ID"),
                                        enabled: !_status,
                                        controller: _emailController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Phone Number',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter your Number"),
                                        enabled: false,
                                        controller: _phoneController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
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
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "House No/Flat No"),
                                        enabled: !_status,
                                        controller: _addressController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Address 2',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        // initialValue:
                                        //     '${object[0]["contact_no"]}',
                                        decoration: const InputDecoration(
                                            hintText: "Street/Locality"),
                                        enabled: !_status,
                                        controller: _address2Controller,
                                      ),
                                    ),
                                  ],
                                )),
                                Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                              child: CSCPicker(
                                
                                currentCity: cityValue,
                                currentState: stateValue,
                                currentCountry: 'India',
                                defaultCountry: CscCountry.India,
                                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                showStates: true,
                                
                                countrySearchPlaceholder: "Search Your Country",
                                stateSearchPlaceholder: "Search Your State",
                                citySearchPlaceholder: "Search Your Country",
                                countryDropdownLabel: "Country",
                                stateDropdownLabel: "State",
                                cityDropdownLabel: "City",
  //                         

                                /// Enable disable city drop down [OPTIONAL PARAMETER]
                                showCities: true,
                                layout: Layout.vertical,

                                ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                flagState: CountryFlag.DISABLE,

                                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                dropdownDecoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.transparent,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black45,
                                          width: 0.25)),
                                  // .all(color: Colors.grey.shade300, width: 1)
                                ),
                                

                                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                disabledDropdownDecoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.transparent,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black45,
                                          width: 0.25)),
                                ),

                                ///selected item style [OPTIONAL PARAMETER]
                                selectedItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),

                                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                dropdownHeadingStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),

                                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
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
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 25.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'City',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 2.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Flexible(
                            //           child: new TextFormField(
                            //             // initialValue:
                            //             //     '${object[0]["contact_no"]}',
                            //             decoration: const InputDecoration(
                            //                 hintText: "Enter your City"),
                            //             enabled: !_status,
                            //             controller: _cityController,
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 25.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'State',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 2.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Flexible(
                            //           child: new TextFormField(
                            //             // initialValue:
                            //             //     '${object[0]["contact_no"]}',
                            //             decoration: const InputDecoration(
                            //                 hintText: "Enter your State"),
                            //             enabled: !_status,
                            //             controller: _stateController,
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Expanded(
                                    //   child: Container(
                                    //     child: new Text(
                                    //       'Gender',
                                    //       style: TextStyle(
                                    //           fontSize: 16.0,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ),
                                    //   flex: 2,
                                    // ),
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Pincode',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Flexible(
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(right: 10.0),
                                    //     child: new TextField(
                                    //       decoration: const InputDecoration(
                                    //           hintText: "Enter Gender"),
                                    //       enabled: !_status,
                                    //       controller: _genderController,
                                    //     ),
                                    //   ),
                                    //   flex: 2,
                                    // ),
                                    Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Pincode"),
                                        enabled: !_status,
                                        controller: _pinController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                            Colors.green[400]),),
                child: new Text("Save"),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                  // print(widget.group);

                  CompleteProfile(
                    context,
                    // widget.login_token,
                    imagefile,
                    _nameController.text,
                    _pinController.text,
                    _addressController.text,
                    _address2Controller.text,
                    _emailController.text,
                    _phoneController.text,
                    cityValue!,
                    stateValue!,
                    // _cityController.text,
                    // _stateController.text,
                    // widget.group
                  );
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),),
                child: new Text("Cancel"),

                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                // ignore: unnecessary_new
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return 
     SizedBox(
                                            height: 40,
                                            // width: 80,
                                            child: OutlinedButton(
                                            
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              onPressed: () async {
                                                 setState(() {
          _status = false;
        });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.green),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0),
                                                ),
                                              ),
                                            ));
    
    
    new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
