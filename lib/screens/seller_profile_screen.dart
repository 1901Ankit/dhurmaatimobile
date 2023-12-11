import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/appBarDrawer.dart';
import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

import '../Constants/constants.dart';

class SellerProfile extends StatefulWidget {
  // const SellerProfile({Key? key}) : super(key: key);
  final List object;
  SellerProfile(this.object);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
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
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    child: Container(
                        alignment: Alignment(0.0, 2.5),
                        child: InkWell(
                          onTap: () async {
                            // await showDialog(
                            // context: context,
                            // builder: (_) => imageDialog(
                            //     '${widget.datapass.name} Profile Picture',
                            //     widget.avatar,
                            //     context));
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.object[0]['avatar'],
                            imageBuilder: (context, imageProvider) => Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                        //  CircleAvatar(
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       await showDialog(
                        //           context: context,
                        //           builder: (_) => imageDialog(
                        //               '${widget.datapass.name} Profile Picture',
                        //               widget.avatar,
                        //               context));
                        //     },
                        //   ),
                        //   backgroundImage: NetworkImage(widget.avatar),
                        //   radius: 60.0,
                        // ),
                        ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${widget.object[0]['name']}",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Color.fromARGB(255, 30, 32, 33),
                      letterSpacing: 2.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.object[0]['contact_no']}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.object[0]['state']}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black45,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Products",
                  style: TextStyle(
                      color: Color.fromARGB(255, 64, 35, 18),
                      fontSize: 32.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 25,
                ),
                widget.object[0]['products'].isNotEmpty
                    ? ListView.builder(
                        // scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.object[0]['products'].length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              // onTap: () {
                              //   List<dynamic> formDb = [
                              //     widget.datapass.farmes[index]
                              //   ];
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             widget.group == "Super_Admin" ||
                              //                     widget.group == "coordinator"
                              //                 ? SelfFarm(formDb, widget.group,
                              //                     widget.token)
                              //                 : Farm(formDb, widget.group,
                              //                     widget.token)),
                              //   );
                              // },
                              child: Card(
                            // color: widget.datapass.farmes[index]["status"]
                            //     ? Colors.green.shade300
                            //     : Colors.blue.shade300,
                            margin: EdgeInsets.all(20),
                            elevation: 5,
                            // child: SizedBox(
                            //   // padding: EdgeInsets.all(20),
                            //   height: 350,
                            child: Column(
                              children: [
                                // Expanded(
                                Container(
                                  // width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(25, 14, 7, 0.9),
                                    // borderRadius:
                                    //     BorderRadius.only(
                                    //         bottomLeft: Radius
                                    //             .circular(
                                    //                 4.0),
                                    //         bottomRight: Radius
                                    //             .circular(
                                    //                 4.0))
                                  ),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20),
                                      Text(
                                        "${widget.object[0]['products'][index]["product_name"]}"
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Bold',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                // ),
                                CarouselSlider.builder(
                                  itemCount: widget
                                      .object[0]['products'][index]
                                          ["product_images"]
                                      .length,
                                  itemBuilder: (BuildContext context, int ind,
                                      int realidx) {
                                    return Container(
                                      margin: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "${widget.object[0]['products'][index]["product_images"][ind]["url"]}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 180.0,
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
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Net Weight",
                                        // "${widget.datapass.farmes[index]["type"] == "crop" ? "Farm area" : "Total Trees"}",
                                        style: TextStyle(
                                          // color: Colors.white,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            // color: Colors.white,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.right,
                                          "${widget.object[0]['products'][index]["net_wt"]} grams"),
                                      // "${widget.datapass.farmes[index]["type"] == "crop" ? "${widget.datapass.farmes[index]["remaining_area"]} Sq Mtr" : "${widget.datapass.farmes[index]["remaining_tree"]} trees"}"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Selling Price",
                                        style: TextStyle(
                                          // color: Colors.white,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            // color: Colors.white,
                                            fontSize: 13,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.right,
                                          "₹ ${widget.object[0]['products'][index]["mrp"]}"
                                          // "${widget.datapass.farmes[index]["address"]}"
                                          ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Unit Price(MRP)",
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Bold',
                                            // color: Colors.white,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              // color: Colors.white,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.right,
                                            "₹ ${widget.object[0]['products'][index]["unit_price"]}"
                                            // "${widget.datapass.farmes[index]["sowing_month"]}"
                                            ),
                                      ]),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          style: TextStyle(
                                            // color: Colors.white,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.left,
                                          "Subscription Status"),
                                      Text(
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          // color: Colors.white,
                                        ),
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.right,
                                        "${widget.object[0]['products'][index]["subscription"] ? 'Subscribed' : 'Unsubscribed'}",
                                        // "${widget.datapass.farmes[index]["harvest_month"]}"
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                            // )
                            // ),
                          ));
                        })
                    : Text(
                        "No Products Listed",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                      ),
                SizedBox(
                  height: 30,
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }
}

// // import 'dart:js';
// import 'dart:convert';
// import 'package:allcanfarmapp/self_farm.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart' as http;
// import 'package:allcanfarmapp/Farm.dart';
// import 'package:allcanfarmapp/FarmerData.dart';
// import 'package:allcanfarmapp/constant.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SelectedProfile extends StatefulWidget {
//   final FarmerData datapass;
//   final String group;
//   final String token;
//   final String avatar;
//   final int user_id;
//   SelectedProfile(
//       this.datapass, this.group, this.token, this.avatar, this.user_id);

//   @override
//   State<SelectedProfile> createState() => _SelectedProfileState();
// }

// class _SelectedProfileState extends State<SelectedProfile> {
//   bool mode = true;
//   late final int rating;

//   // Future getRating(int user_id) async {
//   //   final prefManager = await SharedPreferences.getInstance();
//   //   String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
//   //   final response = await http.post(
//   //     Uri.parse('${Constant.KEY_URL1}/api/get-rating'),
//   //     headers: <String, String>{
//   //       'Content-Type': 'application/json; charset=UTF-8',
//   //       'Authorization': 'Bearer $login_token',
//   //     },
//   //     body: jsonEncode({
//   //       "user_id": user_id,
//   //     }),
//   //   );
//   //   if (response.statusCode == 200) {
//   //     var jcode = jsonDecode(response.body);
//   //     var resp = jcode["response"];
//   //     var message = resp["message"];
//   //     int rate = message["avg_rating"];
//   //     print(message);
//   //     print(jcode);
//   //     setState(() {
//   //       rating = rate;
//   //       print(rating);
//   //       print(rate);
//   //     });
//   //   }
//   // }

//   // @override
//   // initState() {
//   //   getRating(widget.user_id);
//   // }

//   Widget imageDialog(text, path, context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       // elevation: 0,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '$text',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                       color: Colors.white),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: Icon(Icons.close_rounded),
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             // width: 220,
//             // height: 200,
//             child: Image.network(
//               '$path',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String capitalizeAllWord(String value) {
//     var result = value[0].toUpperCase();
//     for (int i = 1; i < value.length; i++) {
//       if (value[i - 1] == " ") {
//         result = result + value[i].toUpperCase();
//       } else {
//         result = result + value[i];
//       }
//     }
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(widget.datapass.farmes);
//     // print(datapass.user_id);
//     return Scaffold(
//         appBar: AppBar(
//           leading: const BackButton(
//             color: Colors.black, // <-- SEE HERE
//           ),
//           backgroundColor: Colors.white,
//           title: Text(
//             'Selected Farmer Profile',
//             style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
//           ),
//         ),
//         body: ListView(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/background.jpg'),
//                           fit: BoxFit.cover)),
//                   child: Container(
//                     width: double.infinity,
//                     height: 200,
//                     child: Container(
//                         alignment: Alignment(0.0, 2.5),
//                         child: InkWell(
//                           onTap: () async {
//                             await showDialog(
//                                 context: context,
//                                 builder: (_) => imageDialog(
//                                     '${widget.datapass.name} Profile Picture',
//                                     widget.avatar,
//                                     context));
//                           },
//                           child: CachedNetworkImage(
//                             imageUrl: widget.avatar,
//                             imageBuilder: (context, imageProvider) => Container(
//                               width: 120.0,
//                               height: 120.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                     image: imageProvider, fit: BoxFit.cover),
//                               ),
//                             ),
//                             placeholder: (context, url) =>
//                                 CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           ),
//                         )
//                         //  CircleAvatar(
//                         //   child: GestureDetector(
//                         //     onTap: () async {
//                         //       await showDialog(
//                         //           context: context,
//                         //           builder: (_) => imageDialog(
//                         //               '${widget.datapass.name} Profile Picture',
//                         //               widget.avatar,
//                         //               context));
//                         //     },
//                         //   ),
//                         //   backgroundImage: NetworkImage(widget.avatar),
//                         //   radius: 60.0,
//                         // ),
//                         ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 80,
//                 ),
//                 Text(
//                   "${widget.datapass.name}",
//                   style: TextStyle(
//                       fontSize: 25.0,
//                       color: Color.fromARGB(255, 30, 32, 33),
//                       letterSpacing: 2.0,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400),
//                 ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // widget.group == "Farmer"
//                 //     ? Text(
//                 //         "${widget.datapass.mobile}",
//                 //         style: TextStyle(
//                 //             fontSize: 18.0,
//                 //             color: Colors.black45,
//                 //             letterSpacing: 2.0,
//                 //             fontFamily: 'Poppins',
//                 //             fontWeight: FontWeight.w300),
//                 //       )
//                 //     : new Container(),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Farmer",
//                   style: TextStyle(
//                     fontSize: 15.0,
//                     color: Colors.black45,
//                     letterSpacing: 2.0,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // Card(
//                 //     margin:
//                 //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                 //     color: Color.fromARGB(255, 193, 63, 40),
//                 //     elevation: 2.0,
//                 //     child: Padding(
//                 //         padding:
//                 //             EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                 //         child: Text(
//                 //           "3 Stars",
//                 //           style: TextStyle(
//                 //               letterSpacing: 2.0,
//                 //               fontFamily: 'Poppins',
//                 //               color: Colors.white,
//                 //               fontWeight: FontWeight.w700),
//                 //         ))),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Card(
//                   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Text(
//                                 "Age",
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontSize: 22.0,
//                                     fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(
//                                 height: 7,
//                               ),
//                               Text(
//                                 "${widget.datapass.age}",
//                                 style: TextStyle(
//                                   color: Colors.black45,
//                                   fontSize: 22.0,
//                                   fontFamily: 'Poppins',
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Text(
//                                 "Gender",
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontSize: 22.0,
//                                     fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(
//                                 height: 7,
//                               ),
//                               Text(
//                                 "${widget.datapass.gender}",
//                                 style: TextStyle(
//                                   color: Colors.black45,
//                                   fontSize: 22.0,
//                                   fontFamily: 'Poppins',
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Card(
//                 //     margin:
//                 //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                 //     color: Colors.blue[200],
//                 //     elevation: 2.0,
//                 //     child: Padding(
//                 //         padding:
//                 //             EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                 //         child: Text(
//                 //           "Stay(${widget.datapass.farmes[index]["status"]})",
//                 //           style: TextStyle(
//                 //               letterSpacing: 2.0,
//                 //               fontFamily: 'Poppins',
//                 //               fontWeight: FontWeight.w700),
//                 //         ))),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "Farms",
//                   style: TextStyle(
//                       color: Color.fromARGB(255, 64, 35, 18),
//                       fontSize: 32.0,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w900),
//                 ),
//                 SizedBox(
//                   height: 25,
//                 ),
//                 widget.datapass.farmes.isNotEmpty
//                     ? ListView.builder(
//                         // scrollDirection: Axis.vertical,
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: widget.datapass.farmes.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                               onTap: () {
//                                 List<dynamic> formDb = [
//                                   widget.datapass.farmes[index]
//                                 ];
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           widget.group == "Super_Admin" ||
//                                                   widget.group == "coordinator"
//                                               ? SelfFarm(formDb, widget.group,
//                                                   widget.token)
//                                               : Farm(formDb, widget.group,
//                                                   widget.token)),
//                                 );
//                               },
//                               child: Card(
//                                 // color: widget.datapass.farmes[index]["status"]
//                                 //     ? Colors.green.shade300
//                                 //     : Colors.blue.shade300,
//                                 margin: EdgeInsets.all(20),
//                                 elevation: 5,
//                                 // child: SizedBox(
//                                 //   // padding: EdgeInsets.all(20),
//                                 //   height: 350,
//                                 child: Column(
//                                   children: [
//                                     // Expanded(
//                                     Container(
//                                       // width: 300,
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                         color: Color.fromRGBO(25, 14, 7, 0.9),
//                                         // borderRadius:
//                                         //     BorderRadius.only(
//                                         //         bottomLeft: Radius
//                                         //             .circular(
//                                         //                 4.0),
//                                         //         bottomRight: Radius
//                                         //             .circular(
//                                         //                 4.0))
//                                       ),
//                                       child: Row(
//                                         // mainAxisAlignment:
//                                         //     MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(width: 20),
//                                           Text(
//                                             "${capitalizeAllWord(widget.datapass.farmes[index]["crop"])} Farm"
//                                                 .toUpperCase(),
//                                             style: TextStyle(
//                                               fontFamily: 'Poppins-Bold',
//                                               color: Colors.white,
//                                               fontSize: 16,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     // ),
//                                     CarouselSlider.builder(
//                                       itemCount: widget.datapass
//                                           .farmes[index]["farm_pics"].length,
//                                       itemBuilder: (BuildContext context,
//                                           int ind, int realidx) {
//                                         return Container(
//                                           margin: EdgeInsets.all(6.0),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                             image: DecorationImage(
//                                               image: CachedNetworkImageProvider(
//                                                   "${widget.datapass.farmes[index]["farm_pics"][ind]["url"]}"),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       options: CarouselOptions(
//                                         height: 180.0,
//                                         enlargeCenterPage: true,
//                                         autoPlay: true,
//                                         aspectRatio: 16 / 9,
//                                         autoPlayCurve: Curves.fastOutSlowIn,
//                                         enableInfiniteScroll: true,
//                                         autoPlayAnimationDuration:
//                                             Duration(milliseconds: 800),
//                                         viewportFraction: 0.8,
//                                       ),
//                                     ),
//                                     // Container(
//                                     //     // padding: EdgeInsets.only(top: 20),
//                                     //     margin: EdgeInsets.only(
//                                     //         left: 20, right: 20),
//                                     //     child: Image(
//                                     //         image: CachedNetworkImageProvider(
//                                     //       "${widget.datapass.farmes[index]["farm_pics"][0]["url"]}",
//                                     //     ))
//                                     // Image.network(
//                                     // '${widget.datapass.farmes[index]["farm_pics"][0]["url"]}'),
//                                     // ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 20, right: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "${widget.datapass.farmes[index]["type"] == "crop" ? "Farm area" : "Total Trees"}",
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontSize: 13,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                           Text(
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 13,
//                                                 // color: Colors.white,
//                                               ),
//                                               textDirection: TextDirection.ltr,
//                                               textAlign: TextAlign.right,
//                                               "${widget.datapass.farmes[index]["type"] == "crop" ? "${widget.datapass.farmes[index]["remaining_area"]} Sq Mtr" : "${widget.datapass.farmes[index]["remaining_tree"]} trees"}"),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 20, right: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Address",
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontSize: 13,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                           Text(
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 // color: Colors.white,
//                                                 fontSize: 13,
//                                               ),
//                                               textDirection: TextDirection.ltr,
//                                               textAlign: TextAlign.right,
//                                               "${widget.datapass.farmes[index]["address"]}"),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 20, right: 20),
//                                       child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "Sowing Date",
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins-Bold',
//                                                 // color: Colors.white,
//                                                 fontSize: 13,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                             Text(
//                                                 style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 13,
//                                                   // color: Colors.white,
//                                                 ),
//                                                 textDirection:
//                                                     TextDirection.ltr,
//                                                 textAlign: TextAlign.right,
//                                                 "${widget.datapass.farmes[index]["sowing_month"]}"),
//                                           ]),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 20, right: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               style: TextStyle(
//                                                 // color: Colors.white,
//                                                 fontFamily: 'Poppins-Bold',
//                                                 fontSize: 13,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                               "Harvesting Date"),
//                                           Text(
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 13,
//                                                 // color: Colors.white,
//                                               ),
//                                               textDirection: TextDirection.ltr,
//                                               textAlign: TextAlign.right,
//                                               "${widget.datapass.farmes[index]["harvest_month"]}"),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     )
//                                   ],
//                                 ),
//                                 // )
//                                 // ),
//                               ));
//                         })
//                     : Text(
//                         "No Farm Listed",
//                         style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
//                       ),
//                 SizedBox(
//                   height: 30,
//                 ),
//               ],
//             ),
//           ],
//         ));
//   }
// }
