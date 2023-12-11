import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhurmaati/screens/subscription-screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/model/cartModel.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/product_details_page.dart';
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
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:upgrader/upgrader.dart';
import '../model/subscriptionModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:images_picker/images_picker.dart';

import 'dummy.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    DateTime(2021, 8, 13),
  ];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 5)),
  ];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();


    _screens = [
      {"screen": DashBoard(), "title": "DashBoard"},
      {"screen": CartPage(), "title": "Cart"},
      {"screen": OrdersList(), "title": "Orders"},
      {"screen": MyProfile(), "title": "My Account"}
    ];
    _resetSelectedDate();
    getNotifications(context);
    getcategories(context);
    getBanners(context);
    getDashBoardDetails(context);
    // loadCamera();
  }

  void _checkVersion(BuildContext context) async {
    final newVersion = NewVersion(
        androidId: 'com.snapchat.android'
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showAlertIfNecessary(context: context);
    // newVersion.showUpdateDialog(context: context,versionStatus: status);
  }

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  int _selectedScreenIndex = 0;

  late List _screens;

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

  var arr = [
    {'img': Constant.Banner_Image1},
    {'img': Constant.Banner_Image2},
    {'img': Constant.Banner_Image3},
  ];

  // var cart = FlutterCart();

  List<dynamic> notificationList = [];
  List<dynamic> bannerList = [];

  Future getNotifications(BuildContext context,) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-all-products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      var product = message["products"];
      print(product);
      // print(message);
      setState(() {
        notificationList = product;
        print(notificationList);
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

  Future getBanners(BuildContext context,) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-banner'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $login_token',
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
        bannerList = message;
        print(bannerList);
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

  List<dynamic> categoryList = [];

  Future getcategories(BuildContext context,) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/get-category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $login_token',
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
        print(categoryList);
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

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  List dash = [];
  String? group;

  Future getDashBoardDetails(BuildContext context) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);
    setState(() {
      group = prefManager.getString(Constant.KEY_USER_GROUP);
    });
    print(group);
    final response = await http.get(
      Uri.parse('${Constant.KEY_URL}/api/seller-dashboard'),
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
      // print(product);
      // print(message);
      // message.forEach((key, value) {
      //   print('key is $key');

      //   print('value is $value ');
      // });
      setState(() {
        dash = [message];
        print(dash);
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

  String getdiscount(num) {
    return num.toStringAsFixed(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String smallSentence(String bigSentence) {
    if (bigSentence.length > 20) {
      return bigSentence.substring(0, 20) + '..';
    } else {
      return bigSentence;
    }
  }

  String? path;
  Position? _currentPosition;
  String? _currentAddress;
  bool showimg = true;

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
          body: UpgradeAlert(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
                    child: Column(
                      children: [


                        bannerList.isEmpty
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : CarouselSlider.builder(
                          itemCount: bannerList.length,
                          itemBuilder:
                              (BuildContext context, int index, int realidx) {
                            return Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${bannerList[index]['url']}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 200.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 3 / 4,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                            Duration(milliseconds: 800),
                            viewportFraction: 1,
                          ),
                        ),
                        group == "Seller"
                            ? Container(
                            padding: EdgeInsets.all(12.0),
                            child: dash.isEmpty
                                ? Center(
                              child: CircularProgressIndicator(),
                            )
                                : GridView(
                              shrinkWrap: true,
                              // itemCount: file.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisExtent: 70,
                                  mainAxisSpacing: 4.0),
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Color.fromARGB(255, 204, 157, 118),
                                //     borderRadius: BorderRadius.circular(10.0),
                                //   ),
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           Text(
                                //             "Total Orders",
                                //             style: TextStyle(
                                //                 fontSize: 17,
                                //                 fontWeight: FontWeight.bold),
                                //           ),
                                //         ],
                                //       ),
                                //       Text(dash[0]["totalOrders"].toString()),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 193, 63, 41),
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Products Sold",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${dash[0]["total_units_sold"] == null
                                            ? "0"
                                            : dash[0]["total_units_sold"]}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 193, 63, 41),
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Earning",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹ ${dash[0]["total_earning"] == null
                                            ? "0"
                                            : dash[0]["total_earning"]}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                            : new Container(),


                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "All Products ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductListPage("all", 1)),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 193, 63, 41),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        notificationList.isEmpty
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container(
                            height: 400,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: notificationList.length,
                                itemBuilder: ((BuildContext context, index) {
                                  return ScopedModelDescendant<CartModel>(
                                      builder: (context, child, model) {
                                        return Container(
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                15),
                                          ),
                                          width: 170,
                                          // height:
                                          //     350, // set the width of the container to the maximum available width
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .stretch,
                                            // stretch the width of the column to match the container
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  var product = Product(
                                                      id: notificationList[index]
                                                      ["product_id"],
                                                      title: notificationList[index]
                                                      ["product_name"],
                                                      price: double.parse(
                                                          notificationList[index]
                                                          ["new_mrp"]),
                                                      description:
                                                      notificationList[index]
                                                      ["description"],
                                                      qty: 1,
                                                      subscribe:
                                                      notificationList[index]
                                                      ["subscription"],
                                                      imgUrl: notificationList[index]
                                                      ["product_images"][0]
                                                      ["url"],
                                                      user: User(
                                                        contact_no: notificationList[index]["users"]["contact_no"]
                                                            .toString(),
                                                        name: notificationList[index] ["users"]["name"],
                                                        avatar: notificationList[index] ["users"]["avatar"],
                                                      ));
                                                  var products = Productss(
                                                      id: notificationList[index]
                                                      ["product_id"],
                                                      title: notificationList[index]
                                                      ["product_name"],
                                                      price: (notificationList[index]
                                                      ["mrp"])
                                                          .toDouble(),
                                                      description:
                                                      notificationList[index]
                                                      ["description"],
                                                      qty: 1,
                                                      subscribe:
                                                      notificationList[index]
                                                      ["subscription"],
                                                      imgUrl: notificationList[index]
                                                      ["product_images"][0]
                                                      ["url"]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsPage(
                                                                product,
                                                                products)),
                                                  );
                                                  setState(() {});
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    topLeft: Radius.circular(
                                                        15.0),
                                                    topRight: Radius.circular(
                                                        15.0),
                                                  ),
                                                  child: Container(
                                                    height: 170,
                                                    decoration: BoxDecoration(
                                                      // color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(50),
                                                    ),
                                                    // set a fixed height for the image container
                                                    child: Image.network(
                                                      notificationList[index]
                                                      ["product_images"][0][
                                                      "url"],
                                                      // replace with the URL of your image
                                                      width: double
                                                          .infinity,
                                                      // set the width of the image to match the container
                                                      fit: BoxFit
                                                          .cover, // adjust how the image should fit inside the container
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  var product = Product(
                                                      id: notificationList[index]
                                                      ["product_id"],
                                                      title: notificationList[index]
                                                      ["product_name"],
                                                      price: double.parse(
                                                          notificationList[index]
                                                          ["new_mrp"]),
                                                      description:
                                                      notificationList[index]
                                                      ["description"],
                                                      qty: 1,
                                                      subscribe:
                                                      notificationList[index]
                                                      ["subscription"],
                                                      imgUrl: notificationList[index]
                                                      ["product_images"][0]
                                                      ["url"],
                                                      user: User(
                                                          contact_no: notificationList[index]["users"]["contact_no"]
                                                              .toString(),
                                                          name: notificationList[index] ["users"]["name"],
                                                        avatar: notificationList[index] ["users"]["avatar"],
                                                      )
                                                  );
                                                  var products = Productss(
                                                      id: notificationList[index]
                                                      ["product_id"],
                                                      title: notificationList[index]
                                                      ["product_name"],
                                                      price: (notificationList[index]
                                                      ["mrp"])
                                                          .toDouble(),
                                                      description:
                                                      notificationList[index]
                                                      ["description"],
                                                      qty: 1,
                                                      subscribe:
                                                      notificationList[index]
                                                      ["subscription"],
                                                      imgUrl: notificationList[index]
                                                      ["product_images"][0]
                                                      ["url"]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsPage(
                                                                product,
                                                                products)),
                                                  );
                                                  setState(() {});
                                                },
                                                child:
                                                Container(
                                                  // padding: EdgeInsets.all(
                                                  //     16.0), // adjust the padding as needed
                                                  // replace with the background color you want for the description
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Row(children: [
                                                                    Text(
                                                                      "  ${smallSentence(
                                                                          notificationList[index]["product_name"])}",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                    ),
                                                                  ]),
                                                                  SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  Row(children: [
                                                                    Text(
                                                                        "  ${notificationList[index]["net_wt"]} ${notificationList[index]["unit"]}"
                                                                            .toLowerCase()),
                                                                  ]),
                                                                  SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "  ₹" +
                                                                        "${notificationList[index]["new_mrp"]}",
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ₹" +
                                                                        "${notificationList[index]["unit_price"]
                                                                            .toStringAsFixed(
                                                                            2)}  ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                        decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              ),
                                                              Row(children: [
                                                                // Container(
                                                                //   height: 20,
                                                                //   // width: 80,
                                                                //   decoration:
                                                                //       BoxDecoration(
                                                                //           color: Colors
                                                                //                   .green[
                                                                //               400]),
                                                                //   child:
                                                                Text(
                                                                  "  ${getdiscount(
                                                                      notificationList[index]["discount"])}% Off",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green[400],
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                                // )
                                                              ]),
                                                              Row(children: [
                                                                Container(
                                                                  // width: 150,
                                                                  child: Text(
                                                                    "  ${notificationList[index]["availability"]} available",
                                                                    style: TextStyle(
                                                                        fontSize: 12),
                                                                  ),
                                                                ),
                                                              ]),
                                                            ],
                                                          )),
                                                      Center(
                                                        child:
                                                        // ScopedModel.of<CartModel>(
                                                        //                     context,
                                                        //                     rebuildOnChange:
                                                        //                         true)
                                                        //                 .cart
                                                        //                 .length ==
                                                        //             0

                                                        // _products[index].id ==
                                                        //         model.cart[ind].id
                                                        // model.cart.where((element) =>
                                                        //             element.id ==
                                                        //             notificationList[
                                                        //                     index][
                                                        //                 "product_id"]) ==
                                                        //         true
                                                        //     //     &&
                                                        //     // _products[index].id ==
                                                        //     //     model.cart[ind].id
                                                        //     ?
                                                        //     //

                                                        //     Container(
                                                        //         // width: 270,
                                                        //         child: Row(
                                                        //           mainAxisAlignment:
                                                        //               MainAxisAlignment
                                                        //                   .spaceBetween,
                                                        //           children: [
                                                        //             Container(
                                                        //               width: 100,
                                                        //               alignment:
                                                        //                   Alignment
                                                        //                       .center,
                                                        //               child:
                                                        //                   new Row(
                                                        //                 mainAxisAlignment:
                                                        //                     MainAxisAlignment
                                                        //                         .spaceEvenly,
                                                        //                 crossAxisAlignment:
                                                        //                     CrossAxisAlignment
                                                        //                         .center,
                                                        //                 children: <
                                                        //                     Widget>[
                                                        //                   Container(
                                                        //                     height:
                                                        //                         20,
                                                        //                     width:
                                                        //                         20,
                                                        //                     alignment:
                                                        //                         Alignment.center,
                                                        //                     decoration: BoxDecoration(
                                                        //                         color: Color.fromARGB(
                                                        //                             255,
                                                        //                             193,
                                                        //                             63,
                                                        //                             41)),
                                                        //                     child:
                                                        //                         new IconButton(
                                                        //                       padding:
                                                        //                           EdgeInsets.zero,
                                                        //                       splashColor:
                                                        //                           Colors.transparent,
                                                        //                       onPressed:
                                                        //                           () {
                                                        //                         model.updateProduct(model.cart[ind],
                                                        //                             model.cart[ind].qty - 1);
                                                        //                         // model.removeProduct(model.cart[index]);
                                                        //                       },
                                                        //                       icon:
                                                        //                           new Icon(
                                                        //                         Icons.remove,
                                                        //                         size:
                                                        //                             12,
                                                        //                         color:
                                                        //                             Colors.white,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   new Text(
                                                        //                       model
                                                        //                           .cart[
                                                        //                               ind]
                                                        //                           .qty
                                                        //                           .toString(),
                                                        //                       style:
                                                        //                           new TextStyle(fontSize: 20.0)),
                                                        //                   Container(
                                                        //                     height:
                                                        //                         20,
                                                        //                     width:
                                                        //                         20,
                                                        //                     decoration: BoxDecoration(
                                                        //                         color: Color.fromARGB(
                                                        //                             255,
                                                        //                             193,
                                                        //                             63,
                                                        //                             41)),
                                                        //                     child:
                                                        //                         Align(
                                                        //                       alignment:
                                                        //                           Alignment.center,
                                                        //                       child:
                                                        //                           new IconButton(
                                                        //                         padding:
                                                        //                             EdgeInsets.zero,
                                                        //                         onPressed:
                                                        //                             () {
                                                        //                           model.updateProduct(model.cart[ind], model.cart[ind].qty + 1);
                                                        //                           // model.removeProduct(model.cart[index]);
                                                        //                         },
                                                        //                         icon:
                                                        //                             Icon(
                                                        //                           Icons.add,
                                                        //                           color: Colors.white,
                                                        //                           size: 12,
                                                        //                         ),
                                                        //                         // backgroundColor: Colors.white,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                 ],
                                                        //               ),
                                                        //             ),
                                                        //           ],
                                                        //         ),
                                                        //       )
                                                        //     :
                                                        Container(
                                                            height: 30,
                                                            width:
                                                            // 180,
                                                            double.infinity,
                                                            //           margin: !notificationList[index]
                                                            //     ["subscription"]
                                                            // ? EdgeInsets.only(top: 20) : EdgeInsets.only(top: 0),
                                                            padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10,
                                                                0,
                                                                10,
                                                                0),
                                                            // margin:
                                                            // EdgeInsets.only(top: 10),
                                                            child:
                                                            OutlinedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                side: BorderSide(
                                                                    width: 1.5,
                                                                    color: Colors
                                                                        .green),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      4.0),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                'Add',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize:
                                                                    14),
                                                              ),
                                                              onPressed: () {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                  "Product Added to the cart",
                                                                  gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  timeInSecForIosWeb:
                                                                  5,
                                                                  backgroundColor:
                                                                  Colors.green[
                                                                  400],
                                                                  textColor:
                                                                  Colors
                                                                      .white,
                                                                  fontSize:
                                                                  16.0,
                                                                );
                                                                var product = Product(
                                                                    id: notificationList[index]
                                                                    [
                                                                    "product_id"],
                                                                    title: notificationList[index]
                                                                    [
                                                                    "product_name"],
                                                                    price: (notificationList[index]["mrp"])
                                                                        .toDouble(),
                                                                    description:
                                                                    notificationList[index]
                                                                    [
                                                                    "description"],
                                                                    qty: 1,
                                                                    subscribe:
                                                                    notificationList[index]
                                                                    [
                                                                    "subscription"],
                                                                    imgUrl: notificationList[index]
                                                                    ["product_images"][0]
                                                                    ["url"]);
                                                                model
                                                                    .addProduct(
                                                                    product);
                                                                //         Navigator.push(
                                                                //   context,
                                                                //   MaterialPageRoute(
                                                                //       builder:
                                                                //           (context) =>
                                                                //               CartPage()),
                                                                // );
                                                                setState(() {});
                                                              },
                                                            )

                                                        ),
                                                      ),
                                                      notificationList[index]
                                                      ["subscription"]
                                                          ? Container(
                                                          height: 30,
                                                          width: double
                                                              .infinity,
                                                          margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              10, 0, 10, 0),
                                                          // margin:
                                                          // EdgeInsets.only(top: 10),
                                                          child: ScopedModelDescendant<
                                                              SubscriptionModel>(
                                                              builder: (context,
                                                                  child,
                                                                  model) {
                                                                return ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                          Color
                                                                              .fromARGB(
                                                                              255,
                                                                              193,
                                                                              63,
                                                                              41)),
                                                                      shape: MaterialStateProperty
                                                                          .all<
                                                                          RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              // BorderRadius.zero,
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  4)))),
                                                                  child: const Text(
                                                                    'Subscribe',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 14),
                                                                  ),
                                                                  onPressed: () {
                                                                    var product = Productss(
                                                                        id: notificationList[index][
                                                                        "product_id"],
                                                                        title: notificationList[index][
                                                                        "product_name"],
                                                                        price: (notificationList[index]
                                                                        ["mrp"])
                                                                            .toDouble(),
                                                                        description:
                                                                        notificationList[index][
                                                                        "description"],
                                                                        qty: 1,
                                                                        subscribe: notificationList[
                                                                        index][
                                                                        "subscription"],
                                                                        imgUrl: notificationList[index]
                                                                        ["product_images"]
                                                                        [0]["url"]);
                                                                    model
                                                                        .addProduct(
                                                                        product);
                                                                    setState(() {});
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (
                                                                              context) =>
                                                                              SubscriptionPage()),
                                                                    );
                                                                  },
                                                                );
                                                              }))
                                                          : Container(
                                                          height: 30,
                                                          width: double
                                                              .infinity,
                                                          margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              10, 0, 10, 0),
                                                          // margin:
                                                          // EdgeInsets.only(top: 10),
                                                          child: ScopedModelDescendant<
                                                              CartModel>(
                                                              builder: (context,
                                                                  child,
                                                                  model) {
                                                                return ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                          Color
                                                                              .fromARGB(
                                                                              255,
                                                                              193,
                                                                              63,
                                                                              41)),
                                                                      shape: MaterialStateProperty
                                                                          .all<
                                                                          RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              // BorderRadius.zero,
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  4)))),
                                                                  child: const Text(
                                                                    'Buy Now',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 14),
                                                                  ),
                                                                  onPressed: () {
                                                                    var product = Product(
                                                                        id: notificationList[index][
                                                                        "product_id"],
                                                                        title: notificationList[index][
                                                                        "product_name"],
                                                                        price: (notificationList[index]
                                                                        ["mrp"])
                                                                            .toDouble(),
                                                                        description:
                                                                        notificationList[index][
                                                                        "description"],
                                                                        qty: 1,
                                                                        subscribe: notificationList[
                                                                        index][
                                                                        "subscription"],
                                                                        imgUrl: notificationList[index]
                                                                        ["product_images"]
                                                                        [0]["url"]);
                                                                    model
                                                                        .addProduct(
                                                                        product);
                                                                    setState(() {});
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (
                                                                              context) =>
                                                                              CartPage()),
                                                                    );
                                                                  },
                                                                );
                                                              })),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }))),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "Shop by Category",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.all(10),
                            //   child: Text(
                            //     "View All",
                            //     style: TextStyle(
                            //         color: Color.fromARGB(255, 193, 63, 41),
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 20),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          height: 160,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15.0,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: categoryList.isEmpty
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: categoryList.length,
                            itemBuilder: ((BuildContext context, index) {
                              return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListPage(
                                                    "category",
                                                    categoryList[index]
                                                    ["category_id"])),
                                      );
                                    },
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                            child: Container(
                                              alignment: Alignment(0.0, 2.5),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    categoryList[index]
                                                    ["category_image"]),
                                                radius: 40.0,
                                                // backgroundColor: Colors.blue,
                                              ),
                                            )),
                                        SizedBox(height: 10),
                                        Center(
                                          child: Text(
                                            capitalizeAllWord(
                                                categoryList[index]
                                                ["category_name"]),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                          ),

                        ),

                      ],
                    ))),
          ),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }


}

class showimage extends StatelessWidget {
  const showimage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(image!.path),
      height: 300,
    );
  }
}
