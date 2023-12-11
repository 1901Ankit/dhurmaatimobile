import 'dart:convert';
import 'dart:io';

import 'package:dhurmaati/screens/product-management/my_products.dart';
import 'package:dhurmaati/screens/product-management/products.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../Constants/constants.dart';
import '../cart_screen.dart';
import '../login_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import '../orders_screen.dart';
import 'package:http/http.dart' as http;

import 'package:async/async.dart';

class EditProductPage extends StatefulWidget {
  // const AddProductPage({Key? key}) : super(key: key);
  List object;
  List obj;
  // int raw_id;
  EditProductPage(this.object, this.obj);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  int _selectedScreenIndex = 0;

  late List _screens;
  late List<DropdownMenuItem<int>> _menuItems;
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
    _menuItems = List.generate(
      widget.object.length,
      (i) => DropdownMenuItem(
        value: widget.object[i]["category_id"],
        child: Text("${widget.object[i]["category_name"]}"),
      ),
    );
    _value = widget.obj[0]["category_id"];
    _nameController.text = widget.obj[0]["product_name"];
    _netwtController.text = '${widget.obj[0]["net_wt"]}';
    _quantityController.text = '${widget.obj[0]["quantity"]}';
    _descriptionController.text = widget.obj[0]["description"];
    _unitpriceController.text = '${widget.obj[0]["unit_price"]}';
    _discountController.text = '${widget.obj[0]["discount"]}';
    _shelflifeController.text = '${widget.obj[0]["shelf_life"]}';
    radioButtonItem = widget.obj[0]["subscription"];
    id = widget.obj[0]["subscription"] == true ? 1 : 2;
    productstatus = widget.obj[0]["status"];
    ids = widget.obj[0]["status"] == true ? 1 : 2;
    //  _categoryController.text = widget.obj[0][""];
    // }
    dropdownValue = widget.obj[0]["unit"].toString().toLowerCase();
  }

  Future editproduct(
      BuildContext context,
      int category_id,
      int raw_id,
      String name,
      int net_wt,
      int quantity,
      String des,
      double unit,
      double discount,
      bool sub,
      String siunit,
      bool status) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    String? group = prefManager.getString(Constant.KEY_USER_GROUP);
    Map<String, String> headers = {'Authorization': 'Bearer $login_token'};
    final response = await http.put(
      Uri.parse('${Constant.KEY_URL}/api/edit-product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode({
        "product_id": raw_id,
        "category_id": category_id,
        "product_name": name,
        "net_wt": net_wt,
        "quantity": quantity,
        "description": des,
        "unit_price": unit,
        "discount": discount,
        "subscription": sub,
        'status': status,
        'unit': siunit.toUpperCase()
      }),
    );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      var rest = res["response"];
      var message1 = rest["message"];
      // print(data);
      print(message1);

      print(res);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyProductsList()),
          // : Menu()),
          (route) => false);
      Fluttertoast.showToast(
        msg: "$message1",
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
    // print(heading);
    // print(type);
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
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
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _netwtController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _unitpriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _subscriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _shelflifeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool radioButtonItem = false;
  int id = 1;
  bool productstatus = false;
  int ids = 1;
  bool deliverystatus = true;
  int i = 1;
  // final ImagePicker imgpicker = ImagePicker();
  // List<XFile>? imagefiles;

  // openImages() async {
  //   try {
  //     var pickedfiles = await imgpicker.pickMultiImage();
  //     //you can use ImageCourse.camera for Camera capture
  //     if (pickedfiles != null) {
  //       imagefiles = pickedfiles;
  //       setState(() {});
  //     } else if (pickedfiles.length > 10) {
  //       // Fluttertoast.showToast(
  //       //   msg: "please Select Upto 10 images",
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   timeInSecForIosWeb: 1,
  //       //   backgroundColor: Colors.green[400],
  //       //   textColor: Colors.white,
  //       //   fontSize: 16.0,
  //       // );
  //     } else {
  //       print("No image is selected.");
  //     }
  //   } catch (e) {
  //     print("error while picking file.");
  //   }
  // }
  // var items =
  List<String> _locations = ['gm', 'ml']; // Option 2
  String? _selectedLocation;
  late int _value;
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    print(widget.object);
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
        body: widget.object.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    // autovalidate: _autoValidate,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 40),
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Edit Product".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Please edit details for editing product:",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 25.0),
                            child: new Row(
                              children: [
                                Text("Category",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    )),
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
                              ],
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please enter Product name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter your  Product name',
                              labelText: ' Product Name',
                            ),
                            controller: _nameController,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please enter Description';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter Product Description',
                              labelText: ' Description',
                            ),
                            controller: _descriptionController,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please enter Quantity';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter your  Maximum Quantity',
                              labelText: ' Quantity',
                            ),
                            controller: _quantityController,
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.number,
                          //   validator: (value) {
                          //     if (value == '') {
                          //       return '*Required Field! Please Net Weight';
                          //     }
                          //     return null;
                          //   },
                          //   // decoration: InputDecoration(
                          //   //   suffixIcon: PopupMenuButton<String>(
                          //   //     icon: const Icon(Icons.arrow_drop_down),
                          //   //     onSelected: (String value) {
                          //   //       _netwtController.text = value;
                          //   //     },
                          //   //     itemBuilder: (BuildContext context) {
                          //   //       return items.map<PopupMenuItem<String>>(
                          //   //           (String value) {
                          //   //         return new PopupMenuItem(
                          //   //             child: new Text(value), value: value);
                          //   //       }).toList();
                          //   //     },
                          //   //   ),
                          //   // ),
                          //   controller: _netwtController,
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Row(children: [
                              Expanded(
                                  child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: false),
                                validator: (value) {
                                  if (value == '') {
                                    return '*Required Field! Please Net Weight';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Enter Net Weight(in gm)',
                                  labelText: ' Net Weight(in gm)',
                                ),
                                // decoration: InputDecoration(
                                //   suffixIcon: PopupMenuButton<String>(
                                //     icon: const Icon(Icons.arrow_drop_down),
                                //     onSelected: (String value) {
                                //       _netwtController.text = value;
                                //     },
                                //     itemBuilder: (BuildContext context) {
                                //       return items.map<PopupMenuItem<String>>(
                                //           (String value) {
                                //         return new PopupMenuItem(
                                //             child: new Text(value), value: value);
                                //       }).toList();
                                //     },
                                //   ),
                                // ),
                                controller: _netwtController,
                              )),
                              Container(
                                width: 80.0,
                                child: DropdownButton<String>(
                                  // Step 3.
                                  value: dropdownValue,
                                  // Step 4.
                                  items: <String>['gm', 'ml']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  }).toList(),
                                  // Step 5.
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ]),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please enter Price';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Enter Per Unit Price',
                                labelText: ' Price',
                                prefixText: '₹'),
                            controller: _unitpriceController,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please Discount';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Enter discount',
                                labelText: ' Discount(%)',
                                suffixText: '%'),
                            controller: _discountController,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            validator: (value) {
                              if (value == '') {
                                return '*Required Field! Please enter shelf life';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Enter Shelf Life',
                                labelText: ' Shelf Life',
                                suffixText: 'Days'),
                            controller: _shelflifeController,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              // mainAxisAlignment: MainAxisAlignment.c,
                              children: <Widget>[
                                Text(
                                  'Subscription',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: id,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = true;
                                      id = 1;
                                    });
                                  },
                                ),
                                Text(
                                  'True',
                                  style: new TextStyle(fontSize: 17.0),
                                ),
                                Radio(
                                  value: 2,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: id,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = false;
                                      id = 2;
                                    });
                                  },
                                ),
                                Text(
                                  'False',
                                  style: new TextStyle(
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              // mainAxisAlignment: MainAxisAlignment.c,
                              children: <Widget>[
                                Text(
                                  'Status',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: ids,
                                  onChanged: (val) {
                                    setState(() {
                                      productstatus = true;
                                      ids = 1;
                                    });
                                  },
                                ),
                                Text(
                                  'True',
                                  style: new TextStyle(fontSize: 17.0),
                                ),
                                Radio(
                                  value: 2,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: ids,
                                  onChanged: (val) {
                                    setState(() {
                                      productstatus = false;
                                      ids = 2;
                                    });
                                  },
                                ),
                                Text(
                                  'False',
                                  style: new TextStyle(
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // int.parse(_shelflifeController.text) < 5
                          //     ? new Container()
                          //     :
                          Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: new Row(
                              // mainAxisAlignment: MainAxisAlignment.c,
                              children: <Widget>[
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: i,
                                  onChanged: (val) {
                                    setState(() {
                                      deliverystatus = true;
                                      i = 1;
                                    });
                                  },
                                ),
                                Text(
                                  'PAN India',
                                  style: new TextStyle(fontSize: 15.0),
                                ),
                                Radio(
                                  value: 2,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.green.shade400),
                                  groupValue: i,
                                  onChanged: (val) {
                                    setState(() {
                                      deliverystatus = false;
                                      i = 2;
                                    });
                                  },
                                ),
                                Text(
                                  'Specific Location',
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          deliverystatus
                              ? new Container()
                              : TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                                  validator: (value) {
                                    if (value == '') {
                                      return '*Required Field! Please edit Pincode';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter City Code',
                                    labelText: ' City Code',
                                  ),
                                  controller: _pincodeController,
                                ),
                          deliverystatus
                              ? new Container()
                              : Text(
                                  "Enter first 2 digits of a pincode eg(80 if 80XXXX) "),
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
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    primary: Color.fromARGB(255, 193, 63, 40),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  editproduct(
                                      context,
                                      _value,
                                      widget.obj[0]["product_id"],
                                      _nameController.text,
                                      int.parse(_netwtController.text),
                                      int.parse(_quantityController.text),
                                      _descriptionController.text,
                                      int.parse(_unitpriceController.text)
                                          .toDouble(),
                                      double.parse(_discountController.text)
                                          .toDouble(),
                                      radioButtonItem,
                                      dropdownValue!,
                                      productstatus);
                                },
                                child: const Text('Update Product'),
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

class Language {
  final int id;
  final String name;
  // final String languageCode;

  const Language(this.id, this.name);
}
