import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/thank_you_page.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../model/cartModel.dart';
import 'orders_screen.dart';

class SellarDetailPage extends StatefulWidget {
  final notificationList;

  const SellarDetailPage(this.notificationList, {Key? key}) : super(key: key);

  @override
  State<SellarDetailPage> createState() => _SellarDetailPageState();
}

class _SellarDetailPageState extends State<SellarDetailPage>
    with SingleTickerProviderStateMixin {

  late double progresspercent = 0.1;

  @override
  initState() {
    super.initState();
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
          leading: const BackButton(
            color: Colors.black,
            // onPressed:() { Navigator.pop(context, true); }, // <-- SEE HERE
          ),
          title: Text(
            "Seller Details".toUpperCase(),
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        capitalizeAllWord(widget.notificationList["crop"]) + " Farm",// "${capitalizeAllWord(widget.name[0]["crop"])} Farm",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                          // letterSpacing: 2.0,
                          fontFamily: 'Poppins-Bold',
                        ),
                      ),
                      
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:     Text("Address : ${widget.notificationList["address"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                          // style: ButtonStyle(
                          //     backgroundColor: MaterialStateProperty.all(
                          //         Color.fromARGB(255, 193, 63, 41)),
                          //     shape: MaterialStateProperty.all<
                          //         RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ))),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          color:Color.fromARGB(255, 193, 63, 41),
                          elevation: 2.0,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 30),
                              child: Text(
                                "Total Area (${widget.notificationList["farm_area"]} Sq. metre)",//"${widget.name[0]["type"] == "crop" ? "Total Area (${widget.name[0]["farm_area"]} Sq. metre)" : "Total Trees (${widget.name[0]["tree"]} trees)"}",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Poppins'),
                              ))),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Sowing Date",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'Poppins-Bold',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${widget.notificationList["sowing_month"]}",//"${widget.name[0]["sowing_month"]}",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontFamily: 'Poppins',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Harvesting Date",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins-Bold',
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                        "${widget.notificationList["harvest_month"]}",//"${widget.name[0]["harvest_month"]}",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 18.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Card(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: 20.0, vertical: 8.0),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(20.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Expanded(
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "2023-01-01",
                      //                 // widget.token == "carbon_credit"
                      //                 //     ? "Total Credits"
                      //                 //     : "${widget.name[0]["type"] == "crop" ? "Total Area" : "Total Trees"}",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontFamily: 'Poppins-Bold',
                      //                   fontSize: 18.0,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 height: 4,
                      //               ),
                      //               Text(
                      //                 "2023-01-01",
                      //                 // widget.token == "carbon_credit"
                      //                 //     ? "${widget.name[0]["carbon_credit"]}"
                      //                 //     : "${widget.name[0]["type"] == "crop" ? "${widget.name[0]["farm_area"]} Sq. metre" : "${widget.name[0]["tree"]} trees"}",
                      //                 style: TextStyle(
                      //                   color: Colors.black45,
                      //                   fontFamily: 'Poppins',
                      //                   fontSize: 18.0,
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         Expanded(
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "2023-01-01",
                      //                 // widget.token == "carbon_credit"
                      //                 //     ? "Remaining Credits"
                      //                 //     : "${widget.name[0]["type"] == "crop" ? "Remaining Area" : "Remaining Trees"}",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontFamily: 'Poppins-Bold',
                      //                   fontSize: 18.0,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 height: 4,
                      //               ),
                      //               Text(
                      //                 "2023-01-01",
                      //                 // widget.token == "carbon_credit"
                      //                 //     ? "${widget.name[0]["remaining_credit"]}"
                      //                 //     : "${widget.name[0]["type"] == "crop" ? "${widget.name[0]["remaining_area"]} Sq. metre" : "${widget.name[0]["remaining_tree"]} trees"}",
                      //                 style: TextStyle(
                      //                   color: Colors.black45,
                      //                   fontSize: 18.0,
                      //                   fontFamily: 'Poppins',
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      CarouselSlider.builder(
                        itemCount: widget.notificationList["farm_pics"].length,
                        itemBuilder: (BuildContext context, int index,
                            int realidx) {
                          return Container(
                            margin: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "${widget.notificationList["farm_pics"][index]["url"]}"),
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
                      )
                    ],
                  ),
                )),

      ),
    );
  }

}
