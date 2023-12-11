import 'dart:convert';

import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/product_list_page.dart';
import 'package:dhurmaati/screens/seller_list_screen.dart';
import 'package:dhurmaati/screens/seller_screen.dart';
import 'package:dhurmaati/screens/sellers_list_page.dart';
import 'package:dhurmaati/screens/subscription-screen.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cartModel.dart';
import '../model/subscriptionModel.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'main_dashboard_page.dart';
import 'orders_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product formDb;
  final Productss form;
  // const ProductDetailsPage(List formDb, {Key? key}) : super(key: key);
  ProductDetailsPage(this.formDb, this.form);
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late bool isLiked = false;
  int _selectedScreenIndex = 0;
  final TextEditingController _pincodeController = TextEditingController();

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
    // getDetails(context);
    // }
    _getCurrentLocation();
    getRating(context, widget.formDb.id);
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

  Object? rate;
  List rating = [];
// String?
  Future getRating(BuildContext context, int product_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    // String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.get(
        Uri.parse('${Constant.KEY_URL}/api/get-rating')
            .replace(queryParameters: {
          'product_id': product_id.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer $login_token',
        });

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      print(message);
      setState(() {
        rating = [message];
        rate = message;
        // _pincodeController.text = '';
        // message == "available" ? isPresent = true : isPresent = false;
        // zoneList = message;
        // _menuItems = List.generate(
        //   message.length,
        //   (i) => DropdownMenuItem(
        //     value: message[i]["zone_id"],
        //     child: Text("${message[i]["zone_name"]}"),
        //   ),
        // );
        // print(zoneList[0]);
        print(rate);
      });
      // Fluttertoast.showToast(
      //   msg: "This product is $message for delivery in your area",
      //   toastLength: Toast.LENGTH_SHORT,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor:
      //       message == "available" ? Colors.green[400] : Colors.red[400],
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );

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

  Future checkAvailability(
      BuildContext context, int product_id, int pin) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    // String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response =
        await http.post(Uri.parse('${Constant.KEY_URL}/api/check-availability'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // 'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({'product_id': product_id, 'pincode': pin}));

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      // var product = message["products"];
      print(message);
      setState(() {
        _pincodeController.text = '';
        message == "available" ? isPresent = true : isPresent = false;
        // zoneList = message;
        // _menuItems = List.generate(
        //   message.length,
        //   (i) => DropdownMenuItem(
        //     value: message[i]["zone_id"],
        //     child: Text("${message[i]["zone_name"]}"),
        //   ),
        // );
        // print(zoneList[0]);
      });
      Fluttertoast.showToast(
        msg: "This product is $message for delivery in your area",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor:
            message == "available" ? Colors.green[400] : Colors.red[400],
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

  Position? _currentPosition;
  String? _currentAddress;
  bool isPresent = false;
  double? _rating;
  IconData? _selectedIcon;
  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(widget.formDb);
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
          body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        // width: 335,
                        // height: 174,

                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 365,
                                height: 300,
                                child: Image.network(
                                  widget.formDb.imgUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '  ${widget.formDb.title}'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            " ₹${widget.formDb.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: new Icon(isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline),
                            color: Colors.red,
                            // highlightColor: Colors.red,
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SellarListDetailPage(widget.formDb)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Seller : ${widget.formDb.user?.name}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text("View Farms", style: TextStyle(color: Colors.blueAccent[200], fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rating.isEmpty
                        ? new Container()
                        : Text(
                            "${rating[0]["times_rated"]} Ratings ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                    rating.isEmpty
                        ? new Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: rating[0]["avg_rating"] == null
                                  ? 0
                                  : rating[0]["avg_rating"].toDouble() ?? 0.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(children: [
                        Text("Check for delivery",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        isPresent
                            ? new Container()
                            : SizedBox(
                                height: 10,
                              ),
                        isPresent
                            ? Container(
                                child: Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                        maxLines: 5,
                                        "The Product is available for delivery in the location."),
                                  ),
                                ],
                              ))
                            : Row(
                                children: [
                                  // Text(
                                  //   "Delivery:",
                                  //   style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    width: MediaQuery.of(context).size.width /
                                        1.75,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            isDense: true, // Added this
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "Enter Pincode"),
                                        controller: _pincodeController,
                                        keyboardType: TextInputType.number),
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green[400]),
                                      ),
                                      onPressed: () {
                                        checkAvailability(
                                            context,
                                            widget.formDb.id,
                                            int.parse(_pincodeController.text));
                                        // setState(() {
                                        //   isPresent = true;
                                        // });
                                      },
                                      child: Text("Check"))
                                ],
                              ),
                        // isPresent
                        //     ? new Container()
                        //     : InkWell(
                        //         onTap: () {
                        //           _getCurrentLocation();
                        //         },
                        //         child: Text("or Use Current Location "))
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ScopedModelDescendant<CartModel>(
                        builder: (context, child, model) {
                      return Container(
                          height: 60,
                          width: 480,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          // margin:
                          // EdgeInsets.only(top: 10),
                          child: OutlinedButton(
                            // icon: Icon(
                            //   Icons.edit,
                            //   color: Colors.green,
                            //   size: 16,
                            // ),
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onPressed: () async {
                              Fluttertoast.showToast(
                                msg: "Product Added to the cart",
                                gravity: ToastGravity.CENTER,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green[400],
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              model.addProduct(widget.formDb);
                              // Navigator.push(
                              //                                 context,
                              //                                 MaterialPageRoute(
                              //                                     builder:
                              //                                         (context) =>
                              //                                             CartPage()),
                              //                               );
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 1.5, color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ));
                    }),
                    widget.formDb.subscribe
                        ? ScopedModelDescendant<SubscriptionModel>(
                            builder: (context, child, model) {
                            return Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 60,
                                width: 480,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                // margin:
                                // EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green[400]),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  // BorderRadius.zero,
                                                  BorderRadius.circular(4)))),
                                  child: const Text(
                                    'Subscribe',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {
                                    model.addProduct(widget.form);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubscriptionPage()),
                                    );
                                    setState(() {});
                                  },
                                ));
                          })
                        : new Container(),
                    SizedBox(
                      height: 20,
                    ),
                    ScopedModelDescendant<CartModel>(
                        builder: (context, child, model) {
                      return Container(
                          height: 60,
                          width: 480,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          // margin:
                          // EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 193, 63, 41)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            // BorderRadius.zero,
                                            BorderRadius.circular(4)))),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              model.addProduct(widget.formDb);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()),
                              );
                              setState(() {});
                            },
                          ));
                    }),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        capitalizeAllWord(widget.formDb.description),
                        style: TextStyle(fontSize: 13),
                        // maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }

  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        checkAvailability(
            context, widget.formDb.id, int.parse(place.postalCode.toString()));
        print(place);
        print(place.country);
        print(place.administrativeArea);
        print(place.locality);
        print(place.name);
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
