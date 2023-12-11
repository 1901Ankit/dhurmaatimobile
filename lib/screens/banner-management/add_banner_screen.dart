// import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/category_management/category_list_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../../widget/appBarTitle.dart';
import '../../widget/bottomnavigation.dart';
import '../main_dashboard_page.dart';
import 'package:async/async.dart';

import '../orders_screen.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  int _selectedScreenIndex = 0;

  late List _screens;
  // late List<DropdownMenuItem<int>> _menuItems;
  // List dataList =[]
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
    // getDetails(context);

    // }
  }

  File? image;
  bool _isAcceptTermsAndConditions = true;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future addBanner(
    BuildContext context,
    // String name,
    File? imagefile,
  ) async {
    final prefManager = await SharedPreferences.getInstance();

    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    String? group = prefManager.getString(Constant.KEY_USER_GROUP);
    print(group);
    Map<String, String> headers = {'Authorization': 'Bearer $login_token'};
    var req = http.MultipartRequest(
        'POST', Uri.parse('${Constant.KEY_URL}/api/add-banner'));
    // req.fields['category_name'] = name.toString();

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

  final _formKey = GlobalKey<FormState>();
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
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                // autovalidate: _autoValidate,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 40),
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Add Banner".toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Please enter details to add a banner:",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //open button ----------------
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 193, 63, 41)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ))),
                          onPressed: () {
                            // openImages();
                            pickImage();
                          },
                          child: Text(
                            "Upload Images",
                            style: TextStyle(color: Colors.white),
                          )),

                      Text("Picked Files:"),
                      Divider(),
                      image != null
                          ? Image.file(image!)
                          : Text("No image selected"),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: 400,
                          padding: const EdgeInsets.only(top: 40.0),
                          child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  // side: BorderSide(
                                  //     color: Color.fromARGB(255, 193, 63, 40),
                                  //     width: 2 //<-- SEE HERE
                                  //     ),
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Color.fromARGB(255, 193, 63, 40),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              addBanner(context, image!);
                              // if(){}
                              // if (_formKey.currentState!.validate()) {
                              //   AddFarmDetails(
                              //     context,
                              //     // widget.login_token,
                              //     _cropController.text,
                              //     radioButtonItem,
                              //     _treesController.text,
                              //     _sowingController.text,
                              //     _harvestingController.text,
                              //     _produceController.text,
                              //     _costController.text,
                              //     _addressController.text,
                              //     _areaController.text,
                              //     radioButtonItem1,
                              //     // widget.group
                              //   );
                              // }
                            },
                            child: const Text('Add Banner'),
                            // icon: const Icon(Icons.plus_one),
                          )),
                    ],
                  ),
                ))),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }
}
