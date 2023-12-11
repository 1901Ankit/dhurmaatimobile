import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/category_management/add_category_screen.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/category_management/edit_category_screen.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/orders_screen.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../widget/bottomnavigation.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _selectedScreenIndex = 0;

  late List _screens;

  List<dynamic> categoryList = [];
  Future getcategories(
    BuildContext context,
  ) async {
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
        // print(categoryList[3]);
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

  Future deletecategory(BuildContext context, int category_id) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response =
        await http.delete(Uri.parse('${Constant.KEY_URL}/api/delete-category'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"category_id": category_id}));

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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new CategoryList()),
          (route) => false);
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
    getcategories(context);
  }

  List object = [
    {"category_id": 1, "category_name": "Spiecies", "total_product": 2},
    {"category_id": 2, "category_name": "Dairy", "total_product": 4},
    {"category_id": 3, "category_name": "Groceries", "total_product": 3},
  ];

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
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "   Category List ",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategory()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(width: 1.5, color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              categoryList.isEmpty
                  ? Center(
                      child: Text("No Category Available"),
                    )
                  : ListView.builder(
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ProductsList(
                              //           object[index]["products"])),
                              // );
                            },
                            child: Card(
                              // color: Colors.green.shade400,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30),
                              elevation: 5,
                              // child: SizedBox(
                              //   height: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 14, 7, 0.9),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(width: 20),
                                        Text(
                                          "    ${categoryList[index]["category_name"]}"
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Bold',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        PopupMenuButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.ellipsisVertical,
                                              color: Colors.white,
                                            ),
                                            // add icon, by default "3 dot" icon
                                            // icon: Icon(Icons.book)
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text("Edit Category"),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child:
                                                      Text("Delete Category"),
                                                )
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == 0) {
                                                List<dynamic> formDb = [
                                                  categoryList[index]
                                                ];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditCategory(
                                                                formDb)));
                                                print("Edit Post is selected.");
                                              } else if (value == 1) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      width: 300,
                                                      height: 300,
                                                      child: AlertDialog(
                                                        title: Text(
                                                          'Delete Category',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Bold'),
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete the category',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins'),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            textColor:
                                                                Colors.black,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'CANCEL',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            textColor:
                                                                Colors.black,
                                                            onPressed: () {
                                                              deletecategory(
                                                                  context,
                                                                  categoryList[
                                                                          index]
                                                                      [
                                                                      "category_id"]);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'YES',
                                                              style: TextStyle(
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
                                                print(
                                                    "Delete Farm is selected.");
                                              } else if (value == 2) {
                                                print(
                                                    "Logout menu is selected.");
                                              }
                                            }),
                                        // InkWell(
                                        //   onTap: () {
                                        //     List<dynamic> formDb = [
                                        //       categoryList[index]
                                        //     ];
                                        //     Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 EditCategory(formDb)));
                                        //   },
                                        //   child: Text(
                                        //     "Edit   ".toUpperCase(),
                                        //     style: TextStyle(
                                        //       fontFamily: 'Poppins-Bold',
                                        //       color: Colors.white,
                                        //       fontSize: 16,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  CarouselSlider.builder(
                                    itemCount: 1,
                                    itemBuilder: (BuildContext context, int ind,
                                        int realidx) {
                                      return Container(
                                        margin: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                "${categoryList[index]["category_image"]}"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 160.0,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      viewportFraction: 0.8,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.symmetric(
                                  //     horizontal: 20,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //           style: TextStyle(
                                  //             fontFamily: 'Poppins-Bold',
                                  //             fontSize: 13,
                                  //             // color: Colors.white,
                                  //           ),
                                  //           textAlign: TextAlign.left,
                                  //           "Category Name"),
                                  //       Text(
                                  //           style: TextStyle(
                                  //             fontFamily: 'Poppins',
                                  //             // fontSizeMyProducts // color: Colors.white,
                                  //           ),
                                  //           textDirection: TextDirection.ltr,
                                  //           textAlign: TextAlign.right,
                                  //           "${categoryList[index]["category_name"]}"),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                            "Associated Products  "),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "${categoryList[index]["products"] == null ? 0 : categoryList[index]["products"].length}"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                                // ),
                              ),
                            ));
                      })
            ],
          )),
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
        // ),
      ),
    );
  }
}
