import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/product_details_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

import '../model/cartModel.dart';
import '../model/subscriptionModel.dart';
import 'cart_screen.dart';

class ProductListPage extends StatefulWidget {
  // const ProductListPage({Key? key}) : super(key: key);
  final String head;
  final int id;

  // final List<dynamic> notificationList;
  ProductListPage(this.head, this.id);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  String? selectedValue = null;

  // define a list of options for the dropdown
  final List<String> _animals = ["High Price", "Low price"];
  int _selectedScreenIndex = 0;

  late List _screens;
  final TextEditingController _searchController = TextEditingController();

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
    getDetails(context, '');
    // }
  }

  List<dynamic> notificationList = [];

  // List<dynamic> bannerList = [];
  Future getDetails(BuildContext context, String search) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = widget.head == "category"
        ? await http.post(
            Uri.parse('${Constant.KEY_URL}/api/shop-by-category/')
                .replace(queryParameters: {'search': search}),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // 'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"category_id": widget.id}),
          )
        : await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-all-products/')
                .replace(queryParameters: {
              'search': search,
            }),
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
      print(message);
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

  String getdiscount(num) {
    return num.toStringAsFixed(0);
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

  String smallSentence(String bigSentence) {
    if (bigSentence.length > 20) {
      return bigSentence.substring(0, 20) + '..';
    } else {
      return bigSentence;
    }
  }

  // the selected value
  String? _selectedAnimal;

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
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(
                //   height: 30,
                // ),
                Container(
                  // margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              // cursorHeight: 10,
                              controller: _searchController,
                              onChanged: (value) {
                                // farmerList(value);
                                getDetails(context, value);
                              },
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 193, 63, 40))),
                                  hintText: 'Search for anything',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  prefixIcon: Icon(Icons.search),
                                  // suffixIcon: Container(
                                  //   padding: EdgeInsets.all(15),
                                  //   child:
                                  //       Image.asset('assets/images/search.png'),
                                  //   width: 18,
                                  // ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //           child: Container(
                //         width: 150,
                //         height: 50,
                //         padding: EdgeInsets.all(8),
                //         decoration: BoxDecoration(
                //           color: Colors.green[500],
                //           borderRadius:
                //               BorderRadius.circular(20), //<-- SEE HERE
                //         ),
                //         child: Flexible(
                //           child: DropdownButton<String>(
                //             borderRadius: BorderRadius.circular(20),
                //             value: _selectedAnimal,
                //             onChanged: (value) {
                //               setState(() {
                //                 _selectedAnimal = value;
                //               });
                //             },
                //             hint: const Center(
                //                 child: Text(
                //               'Filter',
                //               style: TextStyle(color: Colors.white),
                //             )),
                //             // Hide the default underline
                //             underline: Container(),
                //             // set the color of the dropdown menu
                //             dropdownColor: Colors.white,
                //             icon: const Icon(
                //               Icons.filter_list,
                //               color: Colors.white,
                //             ),
                //             isExpanded: true,

                //             // The list of options
                //             items: _animals
                //                 .map((e) => DropdownMenuItem(
                //                       value: e,
                //                       child: Container(
                //                         alignment: Alignment.centerLeft,
                //                         child: Text(
                //                           e,
                //                           style: const TextStyle(fontSize: 18),
                //                         ),
                //                       ),
                //                     ))
                //                 .toList(),

                //             // Customize the selected item
                //             selectedItemBuilder: (BuildContext context) =>
                //                 _animals
                //                     .map((e) => Center(
                //                           child: Text(
                //                             e,
                //                             style: const TextStyle(
                //                                 fontSize: 18,
                //                                 color: Colors.white,
                //                                 fontStyle: FontStyle.italic,
                //                                 fontWeight: FontWeight.bold),
                //                           ),
                //                         ))
                //                     .toList(),
                //           ),
                //         ),
                //       )),
                //       Container(
                //         width: 200,
                //         // height: 40,
                //         // padding: EdgeInsets.all(8),
                //         decoration: BoxDecoration(
                //           color: Colors.green[500],
                //           borderRadius:
                //               BorderRadius.circular(20), //<-- SEE HERE
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               "  Sort By:",
                //               style: TextStyle(color: Colors.white),
                //             ),
                //             Flexible(
                //               child: DropdownButton<String>(
                //                 borderRadius: BorderRadius.circular(20),
                //                 value: _selectedAnimal,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     _selectedAnimal = value;
                //                   });
                //                 },
                //                 hint: const Center(
                //                     child: Text(
                //                   'Select',
                //                   style: TextStyle(color: Colors.white),
                //                 )),
                //                 // Hide the default underline
                //                 underline: Container(),
                //                 // set the color of the dropdown menu
                //                 dropdownColor: Colors.white,
                //                 icon: const Icon(
                //                   Icons.arrow_drop_down,
                //                   color: Colors.white,
                //                 ),
                //                 isExpanded: true,

                //                 // The list of options
                //                 items: _animals
                //                     .map((e) => DropdownMenuItem(
                //                           value: e,
                //                           child: Container(
                //                             alignment: Alignment.centerLeft,
                //                             child: Text(
                //                               e,
                //                               style:
                //                                   const TextStyle(fontSize: 18),
                //                             ),
                //                           ),
                //                         ))
                //                     .toList(),

                //                 // Customize the selected item
                //                 selectedItemBuilder: (BuildContext context) =>
                //                     _animals
                //                         .map((e) => Center(
                //                               child: Text(
                //                                 e,
                //                                 style: const TextStyle(
                //                                     fontSize: 18,
                //                                     color: Colors.white,
                //                                     fontStyle: FontStyle.italic,
                //                                     fontWeight:
                //                                         FontWeight.bold),
                //                               ),
                //                             ))
                //                         .toList(),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ]),
                SizedBox(
                  height: 10,
                ),
                notificationList.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                            child: Text(
                          "No Products Available ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )))
                    : GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8.0),
                        itemCount: notificationList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 1,
                            childAspectRatio: 0.75,
                            mainAxisExtent: 370),
                        itemBuilder: (context, index) {
                          return ScopedModelDescendant<CartModel>(
                              builder: (context, child, model) {
                            int ind = model.cart.indexWhere((prod) =>
                                prod.id ==
                                notificationList[index]["product_id"]);

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 230,
                              // height:
                              //     350, // set the width of the container to the maximum available width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                          description: notificationList[index]
                                              ["description"],
                                          qty: 1,
                                          subscribe: notificationList[index]
                                              ["subscription"],
                                          imgUrl: notificationList[index]
                                              ["product_images"][0]["url"],
                                          user: User(
                                            contact_no: notificationList[index]
                                                    ["users"]["contact_no"]
                                                .toString(),
                                            name: notificationList[index]
                                                ["users"]["name"],
                                            avatar: notificationList[index]
                                                ["users"]["avatar"],
                                          ));
                                      var products = Productss(
                                          id: notificationList[index]
                                              ["product_id"],
                                          title: notificationList[index]
                                              ["product_name"],
                                          price: (notificationList[index]
                                                  ["mrp"])
                                              .toDouble(),
                                          description: notificationList[index]
                                              ["description"],
                                          qty: 1,
                                          subscribe: notificationList[index]
                                              ["subscription"],
                                          imgUrl: notificationList[index]
                                              ["product_images"][0]["url"]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsPage(
                                                    product, products)),
                                      );
                                      setState(() {});
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                      child: SizedBox(
                                        width: 335,
                                        height: 170,
                                        // decoration: BoxDecoration(
                                        //   // color: Colors.white,
                                        //   borderRadius:
                                        //       BorderRadius.circular(50),
                                        // ), // set a fixed height for the image container
                                        child: Image.network(
                                          notificationList[index]
                                              ["product_images"][0]["url"],
                                          // replace with the URL of your image
                                          width: double.infinity,
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
                                          description: notificationList[index]
                                              ["description"],
                                          qty: 1,
                                          subscribe: notificationList[index]
                                              ["subscription"],
                                          imgUrl: notificationList[index]
                                              ["product_images"][0]["url"],
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
                                          description: notificationList[index]
                                              ["description"],
                                          qty: 1,
                                          subscribe: notificationList[index]
                                              ["subscription"],
                                          imgUrl: notificationList[index]
                                              ["product_images"][0]["url"]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsPage(
                                                    product, products)),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(
                                      //     16.0), // adjust the padding as needed
                                      // replace with the background color you want for the description
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(children: [
                                                        Text(
                                                          "  ${smallSentence(notificationList[index]["product_name"])}",
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
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        " ₹" +
                                                            "${notificationList[index]["unit_price"].toStringAsFixed(2)}  ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
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
                                                      "  ${getdiscount(notificationList[index]["discount"])}% Off",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green[400],
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                            child: Container(
                                                height: 30,
                                                width:
                                                    // 180,
                                                    double.infinity,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                // margin:
                                                // EdgeInsets.only(top: 10),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      193,
                                                                      63,
                                                                      41)),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  // BorderRadius.zero,
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)))),
                                                  child: const Text(
                                                    'View',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  onPressed: () {
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
                                                        subscribe: notificationList[
                                                                index]
                                                            ["subscription"],
                                                        imgUrl: notificationList[
                                                                    index]
                                                                ["product_images"]
                                                            [0]["url"],
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
                                                        price:
                                                            (notificationList[index]
                                                                    ["mrp"])
                                                                .toDouble(),
                                                        description:
                                                            notificationList[index]
                                                                ["description"],
                                                        qty: 1,
                                                        subscribe:
                                                            notificationList[index][
                                                                "subscription"],
                                                        imgUrl: notificationList[
                                                                    index]
                                                                ["product_images"]
                                                            [0]["url"]);
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
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // return SizedBox(
                            //   width: 150,
                            //   height: 380,
                            //   child: Stack(
                            //     children: <Widget>[
                            //       Card(
                            //         clipBehavior: Clip.antiAliasWithSaveLayer,
                            //         child: Column(
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 var product = Product(
                            //                     id: notificationList[index]
                            //                         ["product_id"],
                            //                     title: notificationList[index]
                            //                         ["product_name"],
                            //                     price: double.parse(
                            //                         notificationList[index]
                            //                             ["new_mrp"]),
                            //                     description:
                            //                         notificationList[index]
                            //                             ["description"],
                            //                     qty: 1,
                            //                     subscribe:
                            //                         notificationList[index]
                            //                             ["subscription"],
                            //                     imgUrl: notificationList[index]
                            //                             ["product_images"][0]
                            //                         ["url"]);
                            //                 var products = Productss(
                            //                     id: notificationList[index]
                            //                         ["product_id"],
                            //                     title: notificationList[index]
                            //                         ["product_name"],
                            //                     price: (notificationList[index]
                            //                             ["mrp"])
                            //                         .toDouble(),
                            //                     description:
                            //                         notificationList[index]
                            //                             ["description"],
                            //                     qty: 1,
                            //                     subscribe:
                            //                         notificationList[index]
                            //                             ["subscription"],
                            //                     imgUrl: notificationList[index]
                            //                             ["product_images"][0]
                            //                         ["url"]);
                            //                 Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           ProductDetailsPage(
                            //                               product, products)),
                            //                 );
                            //                 setState(() {});
                            //               },
                            //               child: SizedBox(
                            //                 width: 335,
                            //                 height: 185,
                            //                 child: Image.network(
                            //                   notificationList[index]
                            //                       ["product_images"][0]["url"],
                            //                   // 'assets/images/Product1.jpg',
                            //                   fit: BoxFit.fill,
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(10.0),
                            //         ),
                            //         // elevation: 5,
                            //         // margin: EdgeInsets.all(10),
                            //       ),
                            //       Positioned(
                            //         top: 180,

                            //         // left: 10,
                            //         child: SizedBox(
                            //           height: 200,
                            //           width: 185,
                            //           child: Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,

                            //             children: [
                            //               SizedBox(height: 10),
                            //               Container(
                            //                   margin: EdgeInsets.symmetric(
                            //                       vertical: 10),
                            //                       padding: EdgeInsets.only(left: 10),
                            //                   child: Column(
                            //                     children: [
                            //                       Column(
                            //                         children: [
                            //                           Row(children: [
                            //                             Text(
                            //                               "  ${notificationList[index]["product_name"]}",
                            //                               style: TextStyle(
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold),
                            //                             ),
                            //                           ]),
                            //                           SizedBox(
                            //                             height: 6,
                            //                           ),
                            //                           Row(children: [
                            //                             Text(
                            //                                 "  ${k_m_b_generator(notificationList[index]["net_wt"])}g"),
                            //                           ]),
                            //                           SizedBox(
                            //                             height: 6,
                            //                           ),
                            //                         ],
                            //                       ),
                            //                       Row(
                            //                         children: [
                            //                           Text(
                            //                             "  ₹" +
                            //                                 "${notificationList[index]["new_mrp"]}",
                            //                             style: TextStyle(
                            //                               fontWeight:
                            //                                   FontWeight.bold,
                            //                             ),
                            //                           ),
                            //                           Text(
                            //                             " ₹" +
                            //                                 "${notificationList[index]["unit_price"].toStringAsFixed(2)}  ",
                            //                             style: TextStyle(
                            //                                 fontWeight:
                            //                                     FontWeight.w300,
                            //                                 decoration:
                            //                                     TextDecoration
                            //                                         .lineThrough),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                       SizedBox(
                            //                         height: 6,
                            //                       ),
                            //                       Row(children: [
                            //                         // Container(
                            //                         //   height: 20,
                            //                         //   // width: 80,
                            //                         //   decoration:
                            //                         //       BoxDecoration(
                            //                         //           color: Colors
                            //                         //                   .green[
                            //                         //               400]),
                            //                         //   child:
                            //                         Text(
                            //                           "  ${getdiscount(notificationList[index]["discount"])}% Off",
                            //                           style: TextStyle(
                            //                               color:
                            //                                   Colors.green[400],
                            //                               fontWeight:
                            //                                   FontWeight.bold),
                            //                         ),
                            //                         // )
                            //                       ]),
                            //                       // Row(children: [
                            //                       //   Container(
                            //                       //     // width: 150,
                            //                       //     child: Text(
                            //                       //       "  ${notificationList[index]["availability"]} available",
                            //                       //       style: TextStyle(fontSize: 13),
                            //                       //     ),
                            //                       //   ),
                            //                       // ]),
                            //                       Center(child:
                            //                        Container(
                            //                                 height: 30,
                            //                                 width:
                            //                                 // 180,
                            //                                 double.infinity,
                            //                                 margin:
                            //                                 EdgeInsets.only(top: 10),
                            //                                 child:
                            //                                     ElevatedButton(
                            //                                   style: ButtonStyle(
                            //                                       backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 193, 63, 41)),
                            //                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            //                                           borderRadius:
                            //                                               // BorderRadius.zero,
                            //                                               BorderRadius.circular(4)))),
                            //                                   child: const Text(
                            //                                     'View',
                            //                                     style: TextStyle(
                            //                                         color: Colors
                            //                                             .white,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .bold,
                            //                                         fontSize:
                            //                                             14),
                            //                                   ),
                            //                                   onPressed: () {

                            //                           var product = Product(
                            //                               id: notificationList[index]
                            //                                   ["product_id"],
                            //                               title: notificationList[index]
                            //                                   ["product_name"],
                            //                               price: double.parse(
                            //                                   notificationList[index]
                            //                                       ["new_mrp"]),
                            //                               description:
                            //                                   notificationList[index]
                            //                                       [
                            //                                       "description"],
                            //                               qty: 1,
                            //                               subscribe: notificationList[index]
                            //                                   ["subscription"],
                            //                               imgUrl: notificationList[
                            //                                           index]
                            //                                       ["product_images"]
                            //                                   [0]["url"]);
                            //                           var products = Productss(
                            //                               id: notificationList[index]
                            //                                   ["product_id"],
                            //                               title: notificationList[index]
                            //                                   ["product_name"],
                            //                               price: (notificationList[
                            //                                       index]["mrp"])
                            //                                   .toDouble(),
                            //                               description:
                            //                                   notificationList[index]
                            //                                       [
                            //                                       "description"],
                            //                               qty: 1,
                            //                               subscribe: notificationList[index]
                            //                                   ["subscription"],
                            //                               imgUrl: notificationList[
                            //                                           index]
                            //                                       ["product_images"]
                            //                                   [0]["url"]);
                            //                           Navigator.push(
                            //                             context,
                            //                             MaterialPageRoute(
                            //                                 builder: (context) =>
                            //                                     ProductDetailsPage(
                            //                                         product,
                            //                                         products)),
                            //                           );
                            //                           setState(() {});
                            //                                   },
                            //                                 )),)

                            //                     ],
                            //                   )),

                            //               // Row(
                            //               //   mainAxisAlignment:
                            //               //       MainAxisAlignment.spaceAround,
                            //               //   children: [
                            //               //     // SizedBox(width: 20),
                            //               //     SizedBox(
                            //               //         height: 25,
                            //               //         width: 140,
                            //               //         child: ElevatedButton(
                            //               //           style: ButtonStyle(
                            //               //               backgroundColor:
                            //               //                   MaterialStateProperty
                            //               //                       .all(Color
                            //               //                           .fromARGB(
                            //               //                               255,
                            //               //                               193,
                            //               //                               63,
                            //               //                               41)),
                            //               //               shape: MaterialStateProperty.all<
                            //               //                       RoundedRectangleBorder>(
                            //               //                   RoundedRectangleBorder(
                            //               //                       borderRadius:
                            //               //                           // BorderRadius.zero,
                            //               //                           BorderRadius
                            //               //                               .circular(
                            //               //                                   4)))),
                            //               //           child: const Text(
                            //               //             'View',
                            //               //             style: TextStyle(
                            //               //                 color: Colors.white,
                            //               //                 fontWeight:
                            //               //                     FontWeight.bold,
                            //               //                 fontSize: 14),
                            //               //           ),
                            //               //           onPressed: () {
                            //               //             var product = Product(
                            //               //                 id: notificationList[index]
                            //               //                     ["product_id"],
                            //               //                 title: notificationList[index]
                            //               //                     ["product_name"],
                            //               //                 price: double.parse(
                            //               //                     notificationList[index]
                            //               //                         ["new_mrp"]),
                            //               //                 description:
                            //               //                     notificationList[index]
                            //               //                         [
                            //               //                         "description"],
                            //               //                 qty: 1,
                            //               //                 subscribe: notificationList[index]
                            //               //                     ["subscription"],
                            //               //                 imgUrl: notificationList[
                            //               //                             index]
                            //               //                         ["product_images"]
                            //               //                     [0]["url"]);
                            //               //             var products = Productss(
                            //               //                 id: notificationList[index]
                            //               //                     ["product_id"],
                            //               //                 title: notificationList[index]
                            //               //                     ["product_name"],
                            //               //                 price: (notificationList[
                            //               //                         index]["mrp"])
                            //               //                     .toDouble(),
                            //               //                 description:
                            //               //                     notificationList[index]
                            //               //                         [
                            //               //                         "description"],
                            //               //                 qty: 1,
                            //               //                 subscribe: notificationList[index]
                            //               //                     ["subscription"],
                            //               //                 imgUrl: notificationList[
                            //               //                             index]
                            //               //                         ["product_images"]
                            //               //                     [0]["url"]);
                            //               //             Navigator.push(
                            //               //               context,
                            //               //               MaterialPageRoute(
                            //               //                   builder: (context) =>
                            //               //                       ProductDetailsPage(
                            //               //                           product,
                            //               //                           products)),
                            //               //             );
                            //               //             setState(() {});
                            //               //           },
                            //               //         )),
                            //               //   ],
                            //               // )
                            //             ],
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // );
                          });
                        },
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
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
