import 'dart:convert';
import 'dart:io';

import 'package:dhurmaati/screens/product-management/my_products.dart';
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

class AddProductPage extends StatefulWidget {
  // const AddProductPage({Key? key}) : super(key: key);
  List object;
  int raw_id;
  AddProductPage(this.object, this.raw_id);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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
    // }
  }

  Future addBasicFarm(
      BuildContext context,
      int category_id,
      int raw_id,
      String name,
      int net_wt,
      int quantity,
      String des,
      int unit,
      int shelflife,
      int pin,
      double discount,
      bool sub,
      bool status,
      String siunit,
      List images) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    String? group = prefManager.getString(Constant.KEY_USER_GROUP);
    Map<String, String> headers = {'Authorization': 'Bearer $login_token'};
    // print(heading);
    // print(type);

    var req = http.MultipartRequest(
        'POST', Uri.parse('${Constant.KEY_URL}/api/add-product'));
    for (var file in images) {
      String fileName = file.path.split("/").last;
      // var stream = new http.ByteStream(Delegating)
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      // get file length

      var length = await file.length(); //imageFile is your image file
      print("File lenght - $length");
      print("fileName - $fileName");
      // multipart that takes file
      var multipartFileSign =
          new http.MultipartFile('files', stream, length, filename: fileName);

      req.files.add(multipartFileSign);
    }
    // req.fields['title'] = heading.toString();
    req.fields['category_id'] = category_id.toString();
    req.fields['raw_material_id'] = raw_id.toString();
    req.fields['product_name'] = name.toString();
    req.fields['net_wt'] = net_wt.toString();
    req.fields['quantity'] = quantity.toString();
    req.fields['description'] = des.toString();
    req.fields['unit_price'] = unit.toString();
    req.fields['discount'] = discount.toString();
    req.fields['subscription'] = sub.toString();
    req.fields['unit'] = siunit.toString().toUpperCase();
    req.fields['shelf_life'] = shelflife.toString();
    req.fields['specific_location'] = pin.toString();
    req.fields['status'] = status.toString();
    req.headers.addAll(headers);
    // req.files.add(http.MultipartFile.fromBytes(
    //     'file', File(image.path).readAsBytesSync(),
    //     filename: image.path));
    if (images.length < 10) {
      var respo = await req.send();

      // print(respo.statusCode);
      if (respo.statusCode == 200) {
        var res = await http.Response.fromStream(respo);
        final result = jsonDecode(res.body);
        var rest = result["response"];
        var message1 = rest["message"];
        print(respo);
        Fluttertoast.showToast(
          msg: "$message1",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[400],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => new MyProductsList()),
            (route) => false);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => new MyDashboard()),
        //     (route) => false);
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
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => new MyProductsList()),
        //     (route) => false);
        throw Exception('Failed to create album.');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please select maximum 10 images.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // List<dynamic> object = [];
  // String? group;

  // Future getDetails(BuildContext context) async {
  //   final prefManager = await SharedPreferences.getInstance();
  //   String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
  //   print(login_token);
  //   setState(() {
  //     group = prefManager.getString(Constant.KEY_USER_GROUP);
  //   });

  //   final response = await http.get(
  //     Uri.parse('${Constant.KEY_URL}/api/get-category'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $login_token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // print("dnfcdfmd $title");
  //     var res = jsonDecode(response.body);
  //     print(res);
  //     var respon = res["response"];
  //     var message = respon["message"];
  //     setState(() {
  //       object = message;
  //       // print(object[0]);
  //     });
  //     Fluttertoast.showToast(
  //       msg: "$message",
  //       toastLength: Toast.LENGTH_SHORT,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green[400],
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   } else if (response.statusCode > 200) {
  //     var data = jsonDecode(response.body);

  //     var rest = data["response"];
  //     var message1 = rest["message"];
  //     print(data);
  //     print(message1);
  //     Fluttertoast.showToast(
  //       msg: "$message1",
  //       toastLength: Toast.LENGTH_SHORT,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red[400],
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: "Internal Server Error Please try again",
  //       toastLength: Toast.LENGTH_SHORT,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green[400],
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     throw Exception('Failed to create album.');
  //   }
  // }

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
  int id = 2;
  bool productstatus = false;
  int ids = 2;
  bool deliverystatus = true;
  int i = 1;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  String dropdownValue = 'gm';

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else if (pickedfiles.length > 10) {
        // Fluttertoast.showToast(
        //   msg: "please Select Upto 10 images",
        //   toastLength: Toast.LENGTH_SHORT,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.green[400],
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  List<dynamic> Category = [
    {"category_id": '1', "category_name": "spieces"},
    {"category_id": '2', "category_name": "dairy"},
    {"category_id": '3', "category_name": "grocery"},
  ];
  List<Language> getLanguages = <Language>[
    Language(1, 'spieces'),
    Language(2, 'dairy'),
    Language(3, 'grocery'),
  ];
  var items = ['gm', 'ml'];
  int _value = 1;
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
                              Text("Add Product".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Please enter details for adding product:",
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
                            keyboardType: TextInputType.number,
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
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Row(children: [
                              Expanded(
                                  child: TextFormField(
                                keyboardType: TextInputType.number,
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
                            keyboardType: TextInputType.number,
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
                                return '*Required Field! Please enter Shelf Life';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Enter Shelf Life',
                                labelText: ' Shelf Life',
                                suffixText: 'Days'),
                            controller: _shelflifeController,
                            // onChanged: (Value){
                            //   _shelflifeController = value;
                            // },
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: new Row(
                              // mainAxisAlignment: MainAxisAlignment.c,
                              children: <Widget>[
                                Text(
                                  'Can be Subscribed?',
                                  style: TextStyle(
                                      fontSize: 15.0,
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
                                  'Yes',
                                  style: new TextStyle(fontSize: 15.0),
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
                                  'No',
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: new Row(
                              // mainAxisAlignment: MainAxisAlignment.c,
                              children: <Widget>[
                                Text(
                                  'Status',
                                  style: TextStyle(
                                      fontSize: 15.0,
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
                                  'Available',
                                  style: new TextStyle(fontSize: 15.0),
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
                                  'N/A',
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // int.parse(_shelflifeController.text) < 5 ||
                          //         int.parse(_shelflifeController.text) == null
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
                                      return '*Required Field! Please add Pincode';
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
                                  "Enter  pincode eg(80XXXX if you are targetting to sell in patna) "),
                          SizedBox(height: 30),

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
                                openImages();
                              },
                              child: Text(
                                "Upload Images",
                                style: TextStyle(color: Colors.white),
                              )),

                          Text("Picked Files:"),
                          Divider(),
                          imagefiles != null
                              ? Container(
                                  height: 300,
                                  child: GridView.count(
                                      // physics:
                                      //     NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      // scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      mainAxisSpacing: 20,
                                      // crossAxisSpacing: 20,
                                      // childAspectRatio: 1,
                                      //  mainAxisExtent: 390
                                      children: List.generate(
                                          growable: false,
                                          imagefiles!.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 250,
                                            child: Column(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() => imagefiles!
                                                          .removeAt(index));
                                                      // setState(() {
                                                      //   imagefiles![index] =
                                                      //       null;
                                                      // });
                                                    },
                                                    child: Icon(Icons.close)),
                                                Image.file(
                                                  File(imagefiles![index].path),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                        return Container(
                                            child: Card(
                                          child: Container(
                                            // height: 100,
                                            // width: 100,
                                            child: Image.file(
                                              File(imagefiles![index].path),
                                              // scale: 1.0,
                                            ),
                                          ),
                                        ));
                                      })))
                              //  Container(
                              //         height: 300,
                              //         child: Wrap(
                              //           children: imagefiles!.map((imageone) {
                              //             return Container(
                              //                 child: Card(
                              //               child: Container(
                              //                 height: 100,
                              //                 width: 100,
                              //                 child:
                              //                     Image.file(File(imageone.path)),
                              //               ),
                              //             ));
                              //           }).toList(growable: false),
                              //         ))
                              : Container(),
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
                                  addBasicFarm(
                                      context,
                                      _value,
                                      widget.raw_id,
                                      _nameController.text,
                                      int.parse(_netwtController.text),
                                      int.parse(_quantityController.text),
                                      _descriptionController.text,
                                      int.parse(_unitpriceController.text),
                                      int.parse(_shelflifeController.text),
                                      int.parse(_pincodeController.text),
                                      double.parse(_discountController.text)
                                          .toDouble(),
                                      radioButtonItem,
                                      productstatus,
                                      dropdownValue,
                                      imagefiles!);
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
                                child: const Text('Add Product'),
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
