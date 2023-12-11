import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/constants.dart';
import '../widget/appBarDrawer.dart';
import '../widget/appBarTitle.dart';
import '../widget/bottomnavigation.dart';
import 'cart_screen.dart';
import 'main_dashboard_page.dart';
import 'main_profile.dart';
import 'orders_screen.dart';

// class NotificationList extends StatefulWidget {
//   // final List object;
//   // final String avatar;
//   // NotificationList();
//   @override
//   _NotificationState createState() => _NotificationState();
// }

// class _NotificationState extends State<NotificationList> {
//   List<dynamic> notificationList = [];
//   Future getNotifications(
//     BuildContext context,
//   ) async {
//     // String fileName = "notification.json";
//     // var dir = await getTemporaryDirectory();
//     // File ntfile = File(dir.path + "/" + fileName);
//     // final connectivityResult = await (Connectivity().checkConnectivity());
//     // print(connectivityResult);
//     // print(">>>>>>>connectivity");
//     // if (connectivityResult == ConnectivityResult.none) {
//     //   showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) {
//     //       return Container(
//     //         width: 300,
//     //         height: 300,
//     //         child: AlertDialog(
//     //           title: Text(
//     //             'No Internet Connection',
//     //             style: TextStyle(fontFamily: 'Poppins-Bold'),
//     //           ),
//     //           content: Text(
//     //             'You are not connected to the internet. To view the page, please join a network.',
//     //             style: TextStyle(fontFamily: 'Poppins'),
//     //           ),
//     //           actions: [
//     //             FlatButton(
//     //               textColor: Colors.black,
//     //               onPressed: () {
//     //                 Navigator.pop(context);
//     //               },
//     //               child: Text(
//     //                 'CANCEL',
//     //                 style: TextStyle(
//     //                   fontFamily: 'Poppins',
//     //                 ),
//     //               ),
//     //             ),
//     //             FlatButton(
//     //               textColor: Colors.black,
//     //               onPressed: () {
//     //                 // Navigator.pop(context);
//     //                 exit(0);
//     //               },
//     //               child: Text(
//     //                 'EXIT APP',
//     //                 style: TextStyle(
//     //                   fontFamily: 'Poppins',
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       );
//     //     },
//     //   );
//     //   if (ntfile.existsSync()) {
//     //     print("Reading from nt file");

//     //     final res = ntfile.readAsStringSync();
//     //     final message = json.decode(res);
//     //     // var resp = message["response"];
//     //     // var message1 = resp["message"];
//     //     setState(() {
//     //       // _isloading = false;
//     //       notificationList = message;
//     //     });
//     //   } else {
//     //     showDialog(
//     //       context: context,
//     //       builder: (BuildContext context) {
//     //         return Container(
//     //           width: 300,
//     //           height: 300,
//     //           child: AlertDialog(
//     //             title: Text(
//     //               'No Internet Connection',
//     //               style: TextStyle(fontFamily: 'Poppins-Bold'),
//     //             ),
//     //             content: Text(
//     //               'You are not connected to the internet. To view the page, please join a network.',
//     //               style: TextStyle(fontFamily: 'Poppins'),
//     //             ),
//     //             actions: [
//     //               FlatButton(
//     //                 textColor: Colors.black,
//     //                 onPressed: () {
//     //                   Navigator.pop(context);
//     //                 },
//     //                 child: Text(
//     //                   'CANCEL',
//     //                   style: TextStyle(
//     //                     fontFamily: 'Poppins',
//     //                   ),
//     //                 ),
//     //               ),
//     //               FlatButton(
//     //                 textColor: Colors.black,
//     //                 onPressed: () {
//     //                   // Navigator.pop(context);
//     //                   exit(0);
//     //                 },
//     //                 child: Text(
//     //                   'EXIT APP',
//     //                   style: TextStyle(
//     //                     fontFamily: 'Poppins',
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         );
//     //       },
//     //     );
//     //   }
//     // } else {
//     print("Reading from internet");

//     final prefManager = await SharedPreferences.getInstance();
//     String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
//     final response = await http.get(
//       Uri.parse('${Constant.KEY_URL}/api/get-notifications'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $login_token',
//       },
//     );

//     if (response.statusCode == 200) {
//       // print("dnfcdfmd $title");
//       var res = jsonDecode(response.body);
//       var resp = res["response"];
//       var message = resp["message"];
//       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//       print(message);
//       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//       setState(() {
//         notificationList = message;
//       });

//       // ntfile.writeAsStringSync(json.encode(message),
//       //     flush: true, encoding: utf8, mode: FileMode.write);
//     } else if (response.statusCode > 200) {
//       var data = jsonDecode(response.body);

//       var rest = data["response"];
//       var message1 = rest["message"];
//       print(data);
//       print(message1);
//       var code = rest["code"];
//       print(data);
//       print(code);
//       print(message1);
//       if (code == 401) {
//         // prefManager.clear();
//         // Navigator.pushAndRemoveUntil(
//         //     context,
//         //     MaterialPageRoute(builder: (context) => HomeScreen()),
//         //     (route) => false);
//         Fluttertoast.showToast(
//           msg: "$message1",
//           toastLength: Toast.LENGTH_SHORT,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red[400],
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: "$message1",
//           toastLength: Toast.LENGTH_SHORT,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red[400],
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Something went wrong please try again.",
//         toastLength: Toast.LENGTH_SHORT,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green[400],
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       throw Exception('Failed to create album.');
//     }
//     // }
//   }

//   int _selectedScreenIndex = 0;

//   late List _screens;
//   void _selectScreen(int index) {
//     setState(() {
//       _selectedScreenIndex = index;
//     });
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => _screens[_selectedScreenIndex]["screen"]),
//     );
//   }

//   @override
//   void initState() {
//     _screens = [
//       {"screen": DashBoard(), "title": "DashBoard"},
//       {"screen": CartPage(), "title": "Cart"},
//       {"screen": OrdersList(), "title": "Orders"},
//       {"screen": MyProfile(), "title": "My Account"}
//     ];
//     getNotifications(context);
//   }

//   // Widget commentChild(data) {
//   //   // print(data);
//   //   // print(data.length);
//   //   return ListView(
//   //     // shrinkWrap: true,
//   //     // physics: NeverScrollableScrollPhysics(),
//   //     children: [
//   //       for (var i = 0; i < data.length; i++)
//   //         Padding(
//   //             padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 6.0),
//   //             child: PhysicalModel(
//   //               color: Colors.white,
//   //               elevation: 18,
//   //               shadowColor: Colors.green.shade50,
//   //               borderRadius: BorderRadius.circular(20),
//   //               child: ListTile(
//   //                 //   shape: RoundedRectangleBorder(
//   //                 //     //<-- SEE HERE
//   //                 //     side: BorderSide(width: 1),
//   //                 //     borderRadius: BorderRadius.circular(20),
//   //                 //   ),
//   //                 leading: GestureDetector(
//   //                   child: Container(
//   //                     height: 50.0,
//   //                     width: 50.0,
//   //                     decoration: new BoxDecoration(
//   //                         color: Colors.blue,
//   //                         borderRadius:
//   //                             new BorderRadius.all(Radius.circular(50))),
//   //                     child: CircleAvatar(
//   //                         radius: 50,
//   //                         backgroundImage:
//   //                             NetworkImage('${data[i]["avatar"]}')),
//   //                   ),
//   //                 ),
//   //                 title: Row(
//   //                   // mainAxisSize: MainAxisSize.min,
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     Text(
//   //                       data[i]['name'].toString(),
//   //                       style: TextStyle(fontWeight: FontWeight.bold),
//   //                     ),
//   //                     data[i]["del_edit"]
//   //                         ? PopupMenuButton(
//   //                             icon: FaIcon(
//   //                               FontAwesomeIcons.ellipsis,
//   //                               color: Colors.black,
//   //                             ),
//   //                             // add icon, by default "3 dot" icon
//   //                             // icon: Icon(Icons.book)
//   //                             itemBuilder: (context) {
//   //                               return [
//   //                                 PopupMenuItem<int>(
//   //                                   value: 0,
//   //                                   child: Text("Edit Comment"),
//   //                                 ),
//   //                                 PopupMenuItem<int>(
//   //                                   value: 1,
//   //                                   child: Text("Delete Comment"),
//   //                                 )
//   //                               ];
//   //                             },
//   //                             onSelected: (value) {
//   //                               if (value == 0) {
//   //                                 showeditAlert(
//   //                                     context,
//   //                                     // data[i]['comment'].toString(),
//   //                                     data[i]['comment_id']);
//   //                                 setState(() {
//   //                                   _textFieldController.text =
//   //                                       data[i]['comment'];
//   //                                 });
//   //                                 // Navigator.push(
//   //                                 //   context,
//   //                                 //   MaterialPageRoute(
//   //                                 //       builder: (context) => AddFarm(widget.name)),
//   //                                 // );
//   //                               } else if (value == 1) {
//   //                                 deletecomment(context, data[i]['comment_id']);
//   //                                 // deleteFarm(context, widget.name[0]["farm_id"]);
//   //                                 print("Delete Farm is selected.");
//   //                               }
//   //                             })
//   //                         : new Container(),
//   //                   ],
//   //                 ),
//   //                 subtitle: Column(
//   //                   children: [
//   //                     Row(
//   //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                         children: [
//   //                           Text(data[i]['comment'].toString()),
//   //                           Text(
//   //                               "${Jiffy("${(data[i]["formatted"])}", "yyyy-MM-dd,hh:mm:ss").fromNow()}")
//   //                         ]),
//   //                     SizedBox(
//   //                       height: 10,
//   //                     )
//   //                   ],
//   //                 ),
//   //                 tileColor:
//   //                     data[i]["del_edit"] ? Colors.grey.shade100 : Colors.white,
//   //               ),
//   //             ))
//   //     ],
//   //   );
//   // }
//   // The key of the list
//   final GlobalKey<AnimatedListState> _key = GlobalKey();

//   // Add a new item to the list
//   // This is trigger when the floating button is pressed
//   // void _addItem() {
//   //   _items.insert(0, "Item ${_items.length + 1}");
//   //   _key.currentState!
//   //       .insertItem(0, duration: const Duration(milliseconds: 100));
//   // }

//   // Remove an item
//   // This is trigger when the trash icon associated with an item is tapped
//   void _removeItem(int index) {
//     _key.currentState!.removeItem(index, (_, animation) {
//       return
//           // SlideTransition(
//           //                                                   key: UniqueKey(),
//           //                             position: Tween<Offset>(
//           //                               begin: const Offset(-1, -0.5),
//           //                               end: const Offset(0, 0),
//           //                             ).animate(animation),
//           FadeTransition(
//         opacity: animation,
//         //   SizeTransition(
//         // sizeFactor: animation,
//         // axis: Axis.horizontal,
//         // axisAlignment: 0.0,
//         child: const Card(
//           margin: EdgeInsets.all(10),
//           elevation: 10,
//           color: Color.fromARGB(255, 78, 146, 82),
//           child: ListTile(
//             contentPadding: EdgeInsets.all(15),
//             title: Text("", style: TextStyle(fontSize: 24)),
//           ),
//         ),
//       );
//       ;
//     }, duration: const Duration(milliseconds: 500));

//     notificationList.removeAt(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(widget.object);
//     return Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(Constant.BackGround_Image),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             iconTheme: IconThemeData(color: Colors.black),
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             title: AppbarTitle(),
//           ),
//           drawer: Appbardrawer(),
//           body: RefreshIndicator(
//               child: Container(
//                 margin: EdgeInsets.only(top: 20, bottom: 20),
//                 child:
//                     // SingleChildScrollView(
//                     //   physics: AlwaysScrollableScrollPhysics(),
//                     //   child:
//                     Column(children: [
//                   Text(
//                     "Notifications ",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   // RaisedButton(
//                   //   child: Text('Clear'),
//                   //   onPressed: () {
//                   //     setState(() {
//                   //       notificationList.clear();
//                   //     });
//                   //   },
//                   // ),
//                   notificationList.isNotEmpty
//                       ?
//                       // ListView.builder(
//                       //     // scrollDirection: Axis.vertical,
//                       //     physics: NeverScrollableScrollPhysics(),
//                       //     shrinkWrap: true,
//                       //     itemCount: notificationList.length,
//                       //     itemBuilder: (context, index) {
//                       //       return Card(
//                       //         surfaceTintColor: Colors.white,
//                       //         margin: EdgeInsets.only(
//                       //             top: 10, bottom: 10, left: 20, right: 20),
//                       //         elevation: 5,
//                       //         child: Padding(
//                       //           padding: EdgeInsets.only(
//                       //             left: 10,
//                       //             top: 10,
//                       //             right: 10,
//                       //             bottom: 10,
//                       //           ),
//                       //           child: Container(
//                       //             // color: Colors.transparent,
//                       //             child: Stack(
//                       //               children: [
//                       //                 Container(
//                       //                   padding: EdgeInsets.all(10),
//                       //                   child: Row(
//                       //                     // mainAxisAlignment:
//                       //                     //     MainAxisAlignment.spaceBetween,
//                       //                     crossAxisAlignment:
//                       //                         CrossAxisAlignment.center,
//                       //                     children: [
//                       //                       Container(
//                       //                           // color: Colors.transparent,
//                       //                           child: Row(
//                       //                         children: [
//                       //                           (DateTime.parse(notificationList[
//                       //                                               index]
//                       //                                           ["time"])
//                       //                                       .difference(
//                       //                                           DateTime
//                       //                                               .now())
//                       //                                       .inDays ==
//                       //                                   0)
//                       //                               ? FaIcon(
//                       //                                   FontAwesomeIcons
//                       //                                       .solidCircle,
//                       //                                   color: Colors.green,
//                       //                                   size: 8,
//                       //                                 )
//                       //                               : new Container(),
//                       //                           SizedBox(
//                       //                             width: 10.0,
//                       //                           ),
//                       //                           // InkWell(
//                       //                           //   //  onTap: () async {
//                       //                           //   //     await showDialog(
//                       //                           //   //         context: context,
//                       //                           //   //         builder: (_) => imageDialog(
//                       //                           //   //             '${farmerData[index]['name']} Profile Picture',
//                       //                           //   //             farmerData[index]
//                       //                           //   //                 ['avatar'],
//                       //                           //   //             context));
//                       //                           //   //   },
//                       //                           //   child: CachedNetworkImage(
//                       //                           //     imageUrl:
//                       //                           //         '${notificationList[index]['avatar']}',
//                       //                           //     imageBuilder: (context,
//                       //                           //             imageProvider) =>
//                       //                           //         Container(
//                       //                           //       width: 60.0,
//                       //                           //       height: 60.0,
//                       //                           //       decoration:
//                       //                           //           BoxDecoration(
//                       //                           //         shape:
//                       //                           //             BoxShape.circle,
//                       //                           //         image: DecorationImage(
//                       //                           //             image:
//                       //                           //                 imageProvider,
//                       //                           //             fit:
//                       //                           //                 BoxFit.cover),
//                       //                           //       ),
//                       //                           //     ),
//                       //                           //     placeholder: (context,
//                       //                           //             url) =>
//                       //                           //         CircularProgressIndicator(),
//                       //                           //     errorWidget: (context,
//                       //                           //             url, error) =>
//                       //                           //         Icon(Icons.error),
//                       //                           //   ),
//                       //                           // ),
//                       //                           // CircleAvatar(
//                       //                           // child: GestureDetector(
//                       //                           //   onTap: () async {
//                       //                           //     await showDialog(
//                       //                           //         context: context,
//                       //                           //         builder: (_) => imageDialog(
//                       //                           //             '${farmerData[index]['name']} Profile Picture',
//                       //                           //             farmerData[index]
//                       //                           //                 ['avatar'],
//                       //                           //             context));
//                       //                           //   },
//                       //                           // ),
//                       //                           // backgroundImage: NetworkImage(
//                       //                           // '${notificationList[index]['avatar']}'),
//                       //                           // radius: 25,
//                       //                           // ),
//                       //                           SizedBox(
//                       //                             width: 10.0,
//                       //                           ),

//                       //                           Container(
//                       //                               width: 250,
//                       //                               child: Text(
//                       //                                 " ${notificationList[index]["message"]}",
//                       //                                 overflow: TextOverflow
//                       //                                     .ellipsis,
//                       //                                 maxLines: 5,
//                       //                                 style: TextStyle(
//                       //                                     color: Colors.black,
//                       //                                     fontFamily:
//                       //                                         'Poppins-Light'),
//                       //                               )),
//                       //                         ],
//                       //                       )
//                       //                           // SizedBox(
//                       //                           //   width: 50.0,
//                       //                           ),
//                       //                     ],
//                       //                   ),
//                       //                 ),
//                       //                 Positioned(
//                       //                   bottom: 0,
//                       //                   right: 1,
//                       //                   child: Text(
//                       //                     "${notificationList[index]["formatted_date_time"]} ",
//                       //                     // textAlign: TextAlign.end,
//                       //                   ),
//                       //                 ),
//                       //               ],
//                       //             ),
//                       //           ),
//                       //         ),
//                       //         // ),
//                       //       );
//                       //     })
//                       Container(
//                           height: MediaQuery.of(context).size.height - 260,
//                           child: AnimatedList(
//                             physics: AlwaysScrollableScrollPhysics(),
//                             key: _key,
//                             initialItemCount: notificationList.length,
//                             padding: const EdgeInsets.all(10),
//                             itemBuilder: (_, index, animation) {
//                               return SizeTransition(
//                                 //                     SlideTransition(
//                                 //                       key: UniqueKey(),
//                                 // position: Tween<Offset>(
//                                 //   begin: const Offset(-1, -0.5),
//                                 //   end: const Offset(0, 0),
//                                 // ).animate(animation),
//                                 key: UniqueKey(),
//                                 sizeFactor: animation,
//                                 child: Card(
//                                   margin: const EdgeInsets.all(10),
//                                   elevation: 10,
//                                   color: Colors.white,
//                                   child: ListTile(
//                                     contentPadding: const EdgeInsets.all(5),
//                                     title: Container(
//                                       // color: Colors.transparent,
//                                       child: Row(children: [
//                                         (DateTime.parse(notificationList[index]
//                                                         ["time"])
//                                                     .difference(DateTime.now())
//                                                     .inDays ==
//                                                 0)
//                                             ? FaIcon(
//                                                 FontAwesomeIcons.solidCircle,
//                                                 color: Colors.green,
//                                                 size: 8,
//                                               )
//                                             : new Container(),
//                                         Container(
//                                             width: 250,
//                                             child: Text(
//                                               " ${notificationList[index]["message"]}",
//                                               overflow: TextOverflow.ellipsis,
//                                               maxLines: 5,
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontFamily: 'Poppins-Light'),
//                                             )),
//                                       ]),
//                                     ),
//                                     subtitle: Text(
//                                         notificationList[index]
//                                             ["formatted_date_time"],
//                                         textAlign: TextAlign.end,
//                                         style: const TextStyle(fontSize: 16)),
//                                     // trailing: IconButton(
//                                     //   icon: const Icon(Icons.delete),
//                                     //   onPressed: () => _removeItem(index),
//                                     // ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ))
//                       : Center(
//                           child: Text(
//                             "No Notifications",
//                             style: TextStyle(fontFamily: 'Poppins'),
//                           ),
//                         ),
//                 ]),
//               ),
//               // ),

//               // child: SingleChildScrollView(
//               // physics: AlwaysScrollableScrollPhysics(),
//               // child: Text("hello how are you ?")),
//               onRefresh: () {
//                 return Future.delayed(Duration(seconds: 1), () {
//                   getNotifications(context);
//                 });
//               }),
//           bottomNavigationBar: BottomMenu(
//             selectedIndex: _selectedScreenIndex,
//             onClicked: _selectScreen,
//           ),
//         ));
//   }
// }

// ??????????????

class NotificationList extends StatefulWidget {
  // final List object;
  // final String avatar;
  // NotificationList();
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationList> {
  List<dynamic> notificationList = [];
  Future getNotifications(
    BuildContext context,
  ) async {
    String fileName = "notification.json";
    var dir = await getTemporaryDirectory();
    File ntfile = File(dir.path + "/" + fileName);
    final connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    print(">>>>>>>connectivity");
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 300,
            height: 300,
            child: AlertDialog(
              title: Text(
                'No Internet Connection',
                style: TextStyle(fontFamily: 'Poppins-Bold'),
              ),
              content: Text(
                'You are not connected to the internet. To view the page, please join a network.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              actions: [
                ElevatedButton(
                  // textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                ElevatedButton(
                  // textColor: Colors.black,
                  onPressed: () {
                    // Navigator.pop(context);
                    exit(0);
                  },
                  child: Text(
                    'EXIT APP',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (ntfile.existsSync()) {
        print("Reading from nt file");

        final res = ntfile.readAsStringSync();
        final message = json.decode(res);
        // var resp = message["response"];
        // var message1 = resp["message"];
        setState(() {
          // _isloading = false;
          notificationList = message;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: 300,
              height: 300,
              child: AlertDialog(
                title: Text(
                  'No Internet Connection',
                  style: TextStyle(fontFamily: 'Poppins-Bold'),
                ),
                content: Text(
                  'You are not connected to the internet. To view the page, please join a network.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                actions: [
                  ElevatedButton(
                    // textColor: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    // textColor: Colors.black,
                    onPressed: () {
                      // Navigator.pop(context);
                      exit(0);
                    },
                    child: Text(
                      'EXIT APP',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      print("Reading from internet");

      final prefManager = await SharedPreferences.getInstance();
      String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
      final response = await http.get(
        Uri.parse('${Constant.KEY_URL}/api/get-notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $login_token',
        },
      );

      if (response.statusCode == 200) {
        // print("dnfcdfmd $title");
        var res = jsonDecode(response.body);
        var resp = res["response"];
        var message = resp["message"];
        setState(() {
          notificationList = message;
          print(notificationList);
        });

        ntfile.writeAsStringSync(json.encode(message),
            flush: true, encoding: utf8, mode: FileMode.write);
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
          prefManager.remove(Constant.KEY_LOGIN_TOKEN);
          prefManager.remove(Constant.KEY_AVATAR_URL);
          prefManager.remove(Constant.KEY_USER_GROUP);
          prefManager.remove(Constant.KEY_USER_ID);
          prefManager.remove(Constant.KEY_AVATAR_URL);
          prefManager.remove(Constant.KEY_USER_GROUP);
          prefManager.remove(Constant.KEY_USER_ID);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
              (route) => false);
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
  }

  Future clearNotifications(
    BuildContext context,
  ) async {
    // } else {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/clear-notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
    );

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      Fluttertoast.showToast(
          msg: "$message",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[400],
          textColor: Colors.white,
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
      getNotifications(context);
      // setState(() {
      //   notificationList = message;
      //   print(notificationList);
      // });

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
        prefManager.remove(Constant.KEY_LOGIN_TOKEN);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
            (route) => false);
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
    // }
  }

  Future clearNotificationsbyId(
      BuildContext context, int notification_id) async {
    // } else {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.post(
        Uri.parse('${Constant.KEY_URL}/api/clear-notification-byID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $login_token',
        },
        body: jsonEncode({"notification_id": notification_id}));

    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];
      Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // setState(() {
      //   notificationList = message;
      //   print(notificationList);
      // });

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
        prefManager.remove(Constant.KEY_LOGIN_TOKEN);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        prefManager.remove(Constant.KEY_AVATAR_URL);
        prefManager.remove(Constant.KEY_USER_GROUP);
        prefManager.remove(Constant.KEY_USER_ID);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
            (route) => false);
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
    // }
  }

  @override
  void initState() {
    getNotifications(context);
  }

  // Widget commentChild(data) {
  //   // print(data);
  //   // print(data.length);
  //   return ListView(
  //     // shrinkWrap: true,
  //     // physics: NeverScrollableScrollPhysics(),
  //     children: [
  //       for (var i = 0; i < data.length; i++)
  //         Padding(
  //             padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 6.0),
  //             child: PhysicalModel(
  //               color: Colors.white,
  //               elevation: 18,
  //               shadowColor: Colors.green.shade50,
  //               borderRadius: BorderRadius.circular(20),
  //               child: ListTile(
  //                 //   shape: RoundedRectangleBorder(
  //                 //     //<-- SEE HERE
  //                 //     side: BorderSide(width: 1),
  //                 //     borderRadius: BorderRadius.circular(20),
  //                 //   ),
  //                 leading: GestureDetector(
  //                   child: Container(
  //                     height: 50.0,
  //                     width: 50.0,
  //                     decoration: new BoxDecoration(
  //                         color: Colors.blue,
  //                         borderRadius:
  //                             new BorderRadius.all(Radius.circular(50))),
  //                     child: CircleAvatar(
  //                         radius: 50,
  //                         backgroundImage:
  //                             NetworkImage('${data[i]["avatar"]}')),
  //                   ),
  //                 ),
  //                 title: Row(
  //                   // mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       data[i]['name'].toString(),
  //                       style: TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     data[i]["del_edit"]
  //                         ? PopupMenuButton(
  //                             icon: FaIcon(
  //                               FontAwesomeIcons.ellipsis,
  //                               color: Colors.black,
  //                             ),
  //                             // add icon, by default "3 dot" icon
  //                             // icon: Icon(Icons.book)
  //                             itemBuilder: (context) {
  //                               return [
  //                                 PopupMenuItem<int>(
  //                                   value: 0,
  //                                   child: Text("Edit Comment"),
  //                                 ),
  //                                 PopupMenuItem<int>(
  //                                   value: 1,
  //                                   child: Text("Delete Comment"),
  //                                 )
  //                               ];
  //                             },
  //                             onSelected: (value) {
  //                               if (value == 0) {
  //                                 showeditAlert(
  //                                     context,
  //                                     // data[i]['comment'].toString(),
  //                                     data[i]['comment_id']);
  //                                 setState(() {
  //                                   _textFieldController.text =
  //                                       data[i]['comment'];
  //                                 });
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(
  //                                 //       builder: (context) => AddFarm(widget.name)),
  //                                 // );
  //                               } else if (value == 1) {
  //                                 deletecomment(context, data[i]['comment_id']);
  //                                 // deleteFarm(context, widget.name[0]["farm_id"]);
  //                                 print("Delete Farm is selected.");
  //                               }
  //                             })
  //                         : new Container(),
  //                   ],
  //                 ),
  //                 subtitle: Column(
  //                   children: [
  //                     Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(data[i]['comment'].toString()),
  //                           Text(
  //                               "${Jiffy("${(data[i]["formatted"])}", "yyyy-MM-dd,hh:mm:ss").fromNow()}")
  //                         ]),
  //                     SizedBox(
  //                       height: 10,
  //                     )
  //                   ],
  //                 ),
  //                 tileColor:
  //                     data[i]["del_edit"] ? Colors.grey.shade100 : Colors.white,
  //               ),
  //             ))
  //     ],
  //   );
  // }
  final leftEditIcon = Container(
    color: Colors.green[400],
    child: Icon(Icons.delete),
    alignment: Alignment.centerLeft,
  );
  final rightDeleteIcon = Container(
    color: Colors.green[400],
    child: Icon(Icons.delete),
    alignment: Alignment.centerRight,
  );
  @override
  Widget build(BuildContext context) {
    // print(widget.object);
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/allback.png"),
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
            body: RefreshIndicator(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  child: notificationList.isNotEmpty
                      ? SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                              child: Column(children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Notifications ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  notificationList.length == 0
                                      ? new Container()
                                      : InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: 300,
                                                  height: 300,
                                                  child: AlertDialog(
                                                    title: Text(
                                                      'Clear All Notifications',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Bold'),
                                                    ),
                                                    content: Text(
                                                      'Are you sure ,you want to clear all notifications? ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                        .green[
                                                                    400]),
                                                        // textColor: Colors.black,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          clearNotifications(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        193,
                                                                        63,
                                                                        40)),
                                                        // textColor: Colors.black,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          // exit(0);
                                                        },
                                                        child: Text(
                                                          'No',
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
                                          },
                                          child: Text("Clear All",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins')),
                                        )
                                ],
                              ),
                            ),
                            ListView.builder(
                                // scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: notificationList.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                      // Each Dismissible must contain a Key. Keys allow Flutter to
                                      // uniquely identify widgets.
                                      key: Key(notificationList[index]
                                              ["notification_id"]
                                          .toString()),
                                      // Provide a function that tells the app
                                      // what to do after an item has been swiped away.
                                      onDismissed: (direction) {
                                        // Remove the item from the data source.
                                        setState(() {
                                          notificationList.removeAt(index);
                                        });
                                        clearNotificationsbyId(
                                            context,
                                            notificationList[index]
                                                ["notification_id"]);

                                        // Then show a snackbar.
                                        // ScaffoldMessenger.of(context)
                                        // .showSnackBar(SnackBar(content: Text('$item dismissed')));
                                      },
                                      background: leftEditIcon,
                                      // right side
                                      secondaryBackground: rightDeleteIcon,
                                      // Show a red background as the item is swiped away.
                                      // background:
                                      //     Container(color: Colors.green[400]),
                                      child: Card(
                                        surfaceTintColor: Colors.white,
                                        margin: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        elevation: 5,
                                        child: Container(
                                          // color: Colors.transparent,
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  // color: Colors.transparent,
                                                  child: Row(
                                                children: [
                                                  (DateTime.parse(notificationList[
                                                                      index]
                                                                  ["time"])
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inDays ==
                                                          0)
                                                      ? FaIcon(
                                                          FontAwesomeIcons
                                                              .solidCircle,
                                                          color: Colors.green,
                                                          size: 8,
                                                        )
                                                      : new Container(),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  // InkWell(
                                                  //   //  onTap: () async {
                                                  //   //     await showDialog(
                                                  //   //         context: context,
                                                  //   //         builder: (_) => imageDialog(
                                                  //   //             '${farmerData[index]['name']} Profile Picture',
                                                  //   //             farmerData[index]
                                                  //   //                 ['avatar'],
                                                  //   //             context));
                                                  //   //   },
                                                  //   child: CachedNetworkImage(
                                                  //     imageUrl:
                                                  //         '${notificationList[index]['avatar']}',
                                                  //     imageBuilder: (context,
                                                  //             imageProvider) =>
                                                  //         Container(
                                                  //       width: 60.0,
                                                  //       height: 60.0,
                                                  //       decoration:
                                                  //           BoxDecoration(
                                                  //         shape:
                                                  //             BoxShape.circle,
                                                  //         image: DecorationImage(
                                                  //             image:
                                                  //                 imageProvider,
                                                  //             fit:
                                                  //                 BoxFit.cover),
                                                  //       ),
                                                  //     ),
                                                  //     placeholder: (context,
                                                  //             url) =>
                                                  //         CircularProgressIndicator(),
                                                  //     errorWidget: (context,
                                                  //             url, error) =>
                                                  //         Icon(Icons.error),
                                                  //   ),
                                                  // ),
                                                  // CircleAvatar(
                                                  // child: GestureDetector(
                                                  //   onTap: () async {
                                                  //     await showDialog(
                                                  //         context: context,
                                                  //         builder: (_) => imageDialog(
                                                  //             '${farmerData[index]['name']} Profile Picture',
                                                  //             farmerData[index]
                                                  //                 ['avatar'],
                                                  //             context));
                                                  //   },
                                                  // ),
                                                  // backgroundImage: NetworkImage(
                                                  // '${notificationList[index]['avatar']}'),
                                                  // radius: 25,
                                                  // ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Container(
                                                      width: 250,
                                                      child: Text(
                                                        "${notificationList[index]["message"]}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins-Light'),
                                                      )),
                                                ],
                                              )
                                                  // SizedBox(
                                                  //   width: 50.0,
                                                  ),
                                            ],
                                          ),
                                        ),
                                        // ),
                                      ));
                                }),
                            SizedBox(
                              height: 20,
                            ),
                          ])))
                      : Center(
                          child: Text(
                            "No Notifications",
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                ),

                // child: SingleChildScrollView(
                // physics: AlwaysScrollableScrollPhysics(),
                // child: Text("hello how are you ?")),
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    getNotifications(context);
                  });
                })));
  }
}
