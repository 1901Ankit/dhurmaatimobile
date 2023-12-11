// import 'package:dhurmaati/screens/product_list_page.dart';
// import 'package:dhurmaati/screens/sellers_list_page.dart';
// import 'package:dhurmaati/widget/appBarDrawer.dart';
// import 'package:dhurmaati/widget/appBarTitle.dart';
// import 'package:dhurmaati/widget/bottomnavigation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import '../Constants/constants.dart';
// import 'product-management/add_product_screen.dart';
// import 'buyer_list_screen.dart';
// import 'cart_screen.dart';
// import 'login_screen.dart';
// import 'main_dashboard_page.dart';
// import 'main_profile.dart';
// import 'orders_screen.dart';

// class WishListPage extends StatefulWidget {
//   const WishListPage({Key? key}) : super(key: key);

//   @override
//   State<WishListPage> createState() => _WishListPageState();
// }

// class _WishListPageState extends State<WishListPage> {
//   int _n = 0;
//   void add() {
//     setState(() {
//       _n++;
//     });
//   }

//   void minus() {
//     setState(() {
//       if (_n != 0) _n--;
//     });
//   }

//   int _selectedScreenIndex = 1;

//   late List _screens;

//   @override
//   initState() {
//     _screens = [
//       {"screen": DashBoard(), "title": "DashBoard"},
//       {"screen": CartPage(), "title": "Cart"},
//       {"screen": OrdersList(), "title": "Orders"},
//       {"screen": MyProfile(), "title": "My Account"}
//     ];
//     // getdata() {
//     // getDashBoard(context);
//     // getPosts(context);
//     // getDetails(context);
//     // }
//   }

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
//   Widget build(BuildContext context) {
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
//           body: Container(
//             margin: EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Text(
//                         "WishList",
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   ListView.builder(
//                       // scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: 2,
//                       itemBuilder: ((context, index) {
//                         return Column(
//                           children: [
//                             Row(children: [
//                               Container(
//                                 height: 120,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     image: DecorationImage(
//                                         image: AssetImage(
//                                             "assets/images/Product1.jpg"),
//                                         fit: BoxFit.fill)),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Container(
//                                     width: 270,
//                                     child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "    Milk",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Align(
//                                               alignment: Alignment.topRight,
//                                               child: IconButton(
//                                                 onPressed: () {},
//                                                 icon: Icon(Icons.close),
//                                                 color: Colors.red,
//                                               )),
//                                         ]),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     "    Pure",
//                                     style: TextStyle(color: Colors.black45),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     "    ₹ 35.00",
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Container(
//                                     width: 270,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           width: 100,
//                                           alignment: Alignment.center,
//                                           child: new Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceEvenly,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: <Widget>[
//                                               Container(
//                                                 height: 20,
//                                                 width: 20,
//                                                 alignment: Alignment.center,
//                                                 decoration: BoxDecoration(
//                                                     color: Color.fromARGB(
//                                                         255, 193, 63, 41)),
//                                                 child: new IconButton(
//                                                   padding: EdgeInsets.zero,
//                                                   splashColor:
//                                                       Colors.transparent,
//                                                   onPressed: minus,
//                                                   icon: new Icon(
//                                                     Icons.remove,
//                                                     size: 12,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                               new Text('$_n',
//                                                   style: new TextStyle(
//                                                       fontSize: 20.0)),
//                                               Container(
//                                                 height: 20,
//                                                 width: 20,
//                                                 decoration: BoxDecoration(
//                                                     color: Color.fromARGB(
//                                                         255, 193, 63, 41)),
//                                                 child: Align(
//                                                   alignment: Alignment.center,
//                                                   child: new IconButton(
//                                                     padding: EdgeInsets.zero,
//                                                     onPressed: add,
//                                                     icon: Icon(
//                                                       Icons.add,
//                                                       color: Colors.white,
//                                                       size: 12,
//                                                     ),
//                                                     // backgroundColor: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Align(
//                                             alignment: Alignment.topRight,
//                                             child: IconButton(
//                                               onPressed: () {},
//                                               icon: Icon(Icons.favorite),
//                                               color: Colors.red,
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ]),
//                             Divider(
//                               height: 20,
//                               thickness: 1,
//                               endIndent: 0,
//                               color: Colors.black45,
//                             ),
//                           ],
//                         );
//                       })),
//                   Container(
//                     margin: EdgeInsets.only(top: 10, bottom: 20),
//                     height: 60,
//                     width: 440,
//                     // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     // color: Color.fromARGB(255, 193, 63, 41),
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                               Color.fromARGB(255, 193, 63, 41)),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ))),
//                       onPressed: () async {
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (context) => CartPage()),
//                             (route) => false);
//                       },
//                       child: Text('Proceed To Cart ▶',
//                           style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           bottomNavigationBar: BottomMenu(
//             selectedIndex: _selectedScreenIndex,
//             onClicked: _selectScreen,
//           ),
//         ));
//   }
// }

import 'package:dhurmaati/widget/appBarTitle.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

// import '../widget.dart';
import '../widget/appBarDrawer.dart';
import './widget.dart';

const kTileHeight = 50.0;

class OrderStatus {
  String step;
  String description;
  bool completed;
  String status;

  OrderStatus(this.step, this.description, this.completed, this.status);
}

class PackageDeliveryTrackingPage extends StatelessWidget {
  final List<OrderStatus> orderStatusList = [
    OrderStatus("Order Placed", "Your order has been placed successfully.",
        true, "Completed"),
    OrderStatus("Processing", "We are currently processing your order.", true,
        "Completed"),
    OrderStatus("Shipped", "Your order has been shipped.", false, "Pending"),
    OrderStatus(
        "Delivered", "Your order has been delivered.", false, "Pending"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
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
        
          body: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Status ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                  children: [
                    // SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        child: Timeline.tileBuilder(
                          shrinkWrap: true,
                          theme: TimelineThemeData(
                            direction: Axis.vertical,
                            
                            nodePosition: 0.05,
                            connectorTheme: ConnectorThemeData(
                              space: 30.0,
                              thickness: 5.0,
                            ),
                            indicatorTheme: IndicatorThemeData(
                              size: 20.0,
                              color: Colors.blue,
                              position: 0,
                              // indicator: _CustomIndicator,
                            ),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.before,
                            // indicatorPositionBuilder: _CustomIndicator,
                            // contentsAlign: ContentsAlign.alternating,
                            itemCount: orderStatusList.length,
                            indicatorBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Toggle the indicator style on tap
                                  // setState(() {
                                  //   _useCircleStyle = !_useCircleStyle;
                                  // });
                                },
                                child: orderStatusList[index].completed
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                      )
                                    : Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue),
                                      ),
                                //  CustomPaint(
                                //   size: Size(30.0, 30.0),
                                //   painter: DotIndicatorPainter(
                                //     color: Colors.blue, // Initial color for circle style
                                //     radius: 5.0, // Initial radius for circle style
                                //     useCircleStyle: _useCircleStyle,
                                //   ),
                                // ),
                              );
                            },
                            connectorBuilder: (_, index, ___) {
                              if (index >= 0) {
                                return SolidLineConnector();
                              }
                              return null;
                            },

                            // indicatorStyle: Indicator.outlined(),
                            contentsBuilder: (context, index) {
                              // indicatorStyle:orderStatusList[index].completed ? Indicator.outlined(backgroundColor: Colors.transparent, child: Icon(Icons.visibility),):IndicatorStyle.dot;
                              return Padding(
                                  padding: EdgeInsets.only(top: 45),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(height: 8.0),
                                      Text(
                                        orderStatusList[index].step,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(orderStatusList[index].description),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Status: ${orderStatusList[index].status}',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomIndicator extends StatelessWidget {
  final Color color;

  const _CustomIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 16.0,
      ),
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key? key,
    required this.orderInfo,
  }) : super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Delivery #${orderInfo.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
          style: TextStyle(
            color: Color(0xffb6b2b2),
          ),
        ),
      ],
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnTimeBar extends StatelessWidget {
  const _OnTimeBar({Key? key, required this.driver}) : super(key: key);

  final _DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('On-time!'),
              ),
            );
          },
          elevation: 0,
          shape: StadiumBorder(),
          color: Color(0xff66c97f),
          textColor: Colors.white,
          child: Text('On-time'),
        ),
        Spacer(),
        // Text(
        //   'Driver\n${driver.name}',
        //   textAlign: TextAlign.center,
        // ),
        // SizedBox(width: 12.0),
        // Container(
        //   width: 40.0,
        //   height: 40.0,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     image: DecorationImage(
        //       fit: BoxFit.fitWidth,
        //       image: NetworkImage(
        //         driver.thumbnailUrl,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
      id: id,
      date: DateTime.now(),
      driverInfo: _DriverInfo(
        name: 'Philipe',
        thumbnailUrl:
            'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
      ),
      deliveryProcesses: [
        _DeliveryProcess(
          'Package Process',
          messages: [
            _DeliveryMessage('8:30am', 'Package received by driver'),
            _DeliveryMessage('11:30am', 'Reached halfway mark'),
          ],
        ),
        _DeliveryProcess(
          'In Transit',
          messages: [
            _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
            _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
          ],
        ),
        _DeliveryProcess.complete(),
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.date,
    required this.driverInfo,
    required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final _DriverInfo driverInfo;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DriverInfo {
  const _DriverInfo({
    required this.name,
    required this.thumbnailUrl,
  });

  final String name;
  final String thumbnailUrl;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}
