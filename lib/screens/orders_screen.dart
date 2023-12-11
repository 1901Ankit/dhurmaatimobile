import 'dart:convert';

import 'package:dhurmaati/screens/order_details.dart';
import 'package:dhurmaati/screens/product-management/add_product_screen.dart';
import 'package:dhurmaati/screens/buyer_list_screen.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constants/constants.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'main_dashboard_page.dart';
import 'main_profile.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  int _selectedScreenIndex = 2;

  late List _screens;
  TextEditingController dateinput = TextEditingController();
  @override
  initState() {
    dateinput.text = "";
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

  List orderList = [];
  Future getDetails(BuildContext context, String date) async {
    print("Reading from internet");

    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = date == ''
        ? await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-my-orders'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
          )
        : await http.get(
            Uri.parse('${Constant.KEY_URL}/api/get-my-orders/')
                .replace(queryParameters: {'date': date}),
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
      // var product = message["products"];
      // print(product);
      // print(message);
      setState(() {
        orderList = message;
        print(orderList);
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

  List obj = [];

  Future getPdfDetail(BuildContext context, int order_id) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    // setState(() {
    //   group = (prefManager.getString(Constant.KEY_USER_GROUP) ?? '');
    // });
    print(order_id);

    final response =
        await http.post(Uri.parse('${Constant.KEY_URL}/api/get-invoice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $login_token',
            },
            body: jsonEncode({"order_id": order_id}));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var res = result["response"];
      var message = res["message"];

      print(message);
      setState(() {
        obj = [message];
      });
      // printPdf();
      // () async {
      final date = DateTime.now();
      final dueDate = date.add(Duration(days: 7));
// factory InvoiceItem.fromJson( Map<String, dynamic> obj[0]["cart_items"]) => AandCDelivery(
//         id: json["_id"],
//         deliveryCategoryId: json["delivery_category_id"],
//         deliveryCategoryName: json["delivery_category_name"],
//         deliveryProductId: json["delivery_product_id"],
//         deliveryProductName: json["delivery_product_name"],
//         deliveryId: json["delivery_id"],
//         userName: json["user_name"],
//         userPhoneNo: json["user_phone_no"],
//         userPicture: json["user_picture"],
//         weight: json["weight"],
//         orderNo: json["order_no"],
//       );
      var data = obj[0]["cart_items"];
// factory InvoiceItem.fromJson(Map<String, dynamic> data) {
//   // note the explicit cast to String
//   // this is required if robust lint rules are enabled
//   final name = data['name'] as String;
//   final cuisine = data['cuisine'] as String;
//   return Restaurant(name: name, cuisine: cuisine);
// };
      var dummyPersonList = obj[0]["cart_items"]
          .map((player) =>
           InvoiceItem(
                description: player["product_name"],
                date: obj[0]["order_date"],
                quantity: player["quantity"],
                gst: 0,
                unitPrice: (player["price"]).toDouble(),
              ))
          .toList();
      print(dummyPersonList);
      List<InvoiceItem> strlist = dummyPersonList.cast<InvoiceItem>();
      // =
      //     List<InvoiceItem>.generate(obj[0]["cart_items"][0], (i) {
      //   return InvoiceItem(
      //     description: obj[0]["cart_items"][i]["product_name"],
      //     date: obj[0]["createdAt"],
      //     quantity: obj[0]["cart_items"][i]["quantity"],
      //     gst: 0,
      //     unitPrice: (obj[0]["cart_items"][i]["price"]).toDouble(),
      //   );
      // });
      print(dummyPersonList);
      final invoice = Invoice(
          supplier: Supplier(
            name: 'DMACF AGRO SERVICES PRIVATE LIMITED',
            address: ' Ashiana Nagar Phase 1, Patna 700136',
            // paymentInfo: 'https://paypal.me/sarahfieldzz',
          ),
          customer: Customer(
              name: obj[0]["customer_details"]["name"],
              address: obj[0]["customer_details"]["address1"],
              address2: obj[0]["customer_details"]["address2"],
              state: obj[0]["customer_details"]["state"],
              City: obj[0]["customer_details"]["city"],
              Pin: obj[0]["customer_details"]["pin"],
              payment_method:obj[0]["payment_method"],
              payment_status: obj[0]["payment_status"] == null ? "To be Paid" : obj[0]["payment_status"] ,
              status: obj[0]["status"]
              ),
          info: InvoiceInfo(
            date:
                obj[0]["order_date"],
            // dueDate: dueDate,
            description: '',
            number: '${DateTime.now().year}-9999',
          ),
          items: strlist
          // [
          // List.generate()
          // List<InvoiceItem> =[],
          // for (int i = 0; i <= obj[0]["cart_items"].length; i++)
          //   {
          // return
          // InvoiceItem(
          //   description: obj[0]["cart_items"][0]["product_name"],
          //   date: obj[0]["createdAt"],
          //   quantity: obj[0]["cart_items"][0]["quantity"],
          //   gst: 0,
          //   unitPrice: (obj[0]["cart_items"][0]["price"]).toDouble(),
          // ),
          //   }
          // InvoiceItem(
          //   description: 'Water',
          //   date: DateTime.now(),
          //   quantity: 8,
          //   vat: 0,
          //   unitPrice: 0.99,
          // ),
          // ],
          );

      final pdfFile = await PdfInvoiceApi.generate(invoice);

      PdfApi.openFile(pdfFile);

      // PdfApi.saveDocument(name: "file.pdf", pdf: pdfFile);
      // };
    }
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
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
              Duration(seconds: 1),
              () {
                getDetails(context, '');
                setState(() {
                  dateinput.text = '';
                });
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "  Orders",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: TextField(
                          controller:
                              dateinput, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: "Enter Date" //label text of field
                              ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                dateinput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                              getDetails(context, formattedDate);
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    orderList.isEmpty
                        ? Container(
                            height: 300,
                            child: Center(
                              child: Text("No Orders Available"),
                            ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: orderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final order = orderList[index];
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          decoration: BoxDecoration(
                                              color: Colors.black),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '  Order #${order["order_id"]}',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.white)),
                                                Text('${order["order_type"]}  ',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.white)),
                                              ])),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Order Date: ${order["new_date"]}',
                                                  style: TextStyle(
                                                      fontSize: 16.0)),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                            'Total Price: ₹${order["total"]}',
                                            style: TextStyle(fontSize: 16.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                            'Order Status : ${order["status"]}',
                                            style: TextStyle(fontSize: 16.0)),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 250,
                                              child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    order['cart_items'].length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int ind) {
                                                  final product =
                                                      order['cart_items'][ind];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Image.network(
                                                            product[
                                                                "image_url"],
                                                            height: 100.0,
                                                            width: 100.0),
                                                        SizedBox(width: 16.0),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  product[
                                                                      'product_name'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0)),
                                                              SizedBox(
                                                                  height: 8.0),
                                                              Text(
                                                                  'Qty: ${product['quantity']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                              SizedBox(
                                                                  height: 8.0),
                                                              Text(
                                                                  'Price: ₹${product['price']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_forward_ios),
                                                  onPressed: () {
                                                    var orders = [order];
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderDetailsPage(
                                                                  orders)),
                                                    );
                                                  },
                                                )),
                                          ]),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                              onTap: () {
                                                getPdfDetail(
                                                    context, order["order_id"]);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                margin: EdgeInsets.only(
                                                    top: 10,
                                                    right: 20,
                                                    bottom: 10),
                                                child: Text("View Bill "),
                                              ))),

                                      // child: Text("view bill"),
                                      // ),
                                      Divider(height: 1.0),
                                    ],
                                  ));
                            },
                          ),
                  ]),
            ),
          ),
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

// /////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';

// class Order {
//   final int id;
//   final DateTime date;
//   final List<Products> products;

//   Order({
//     required this.id,
//     required this.date,
//     required this.products,
//   });
// }

// class Products {
//   final int id;
//   final String name;
//   final String imageUrl;

//   Products({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//   });
// }

// // class OrdersList extends StatefulWidget {
// //   @override
// //   State<OrdersList> createState() => _OrdersListState();
// // }

// // class _OrdersListState extends State<OrdersList> {
// //   List<Order> _orders = [
// //     Order(
// //       id: 1,
// //       date: DateTime.now(),
// //       products: [
// //         Products(
// //             id: 1,
// //             name: 'Product A',
// //             imageUrl:
// //                 'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/WhatsApp%20Image%202023-02-13%20at%2012.36.56.jpeg'),
// //         Products(
// //             id: 2,
// //             name: 'Product B',
// //             imageUrl:
// //                 'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/WhatsApp%20Image%202023-02-13%20at%2012.36.56.jpeg'),
// //       ],
// //     ),
// //     Order(
// //       id: 2,
// //       date: DateTime.now(),
// //       products: [
// //         Products(
// //             id: 3,
// //             name: 'Product C',
// //             imageUrl:
// //                 'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/WhatsApp%20Image%202023-02-13%20at%2012.36.56.jpeg'),
// //         Products(
// //             id: 4,
// //             name: 'Product D',
// //             imageUrl:
// //                 'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/WhatsApp%20Image%202023-02-13%20at%2012.36.56.jpeg'),
// //         Products(
// //             id: 5,
// //             name: 'Product E',
// //             imageUrl:
// //                 'https://dhurmaati.s3.ap-southeast-1.amazonaws.com/WhatsApp%20Image%202023-02-13%20at%2012.36.56.jpeg'),
// //       ],
// //     ),
// //   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Orders')),
//       body: ListView.builder(
//         itemCount: _orders.length,
//         itemBuilder: (BuildContext context, int index) {
//           final order = _orders[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Text('Order #${order.id}',
//                     style: TextStyle(fontSize: 18.0)),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Text('Order Date: ${order.date}',
//                     style: TextStyle(fontSize: 16.0)),
//               ),
//               ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: order.products.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final product = order.products[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     child: Row(
//                       children: <Widget>[
//                         Image.network(product.imageUrl,
//                             height: 100.0, width: 100.0),
//                         SizedBox(width: 16.0),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(product.name,
//                                   style: TextStyle(fontSize: 18.0)),
//                               SizedBox(height: 8.0),
//                               Text('Qty: 1', style: TextStyle(fontSize: 16.0)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               Divider(height: 1.0),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// Container(
//   margin: EdgeInsets.all(10),
//   child: SingleChildScrollView(
//       child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "  Order's List ",
//         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       orderList.isEmpty
//           ? Center(
//               child: Text("No orders Available"),
//             )
//           : ListView.builder(
//               // scrollDirection: Axis.vertical,
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: orderList.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                     onTap: () {},
//                     child: Card(
//                       // color: Colors.green.shade400,
//                       margin: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 30),
//                       elevation: 5,
//                       child: SizedBox(
//                         height: 150,
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.stretch,
//                           children: [
//                             // Expanded(
//                             //   child:
//                             Container(
//                               // width: 300,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 color: Color.fromRGBO(25, 14, 7, 0.9),
//                                 // borderRadius:
//                                 //     BorderRadius.only(
//                                 //         bottomLeft: Radius
//                                 //             .circular(
//                                 //                 4.0),
//                                 //         bottomRight: Radius
//                                 //             .circular(
//                                 //                 4.0))
//                               ),
//                               child: Row(
//                                 // mainAxisAlignment:
//                                 //     MainAxisAlignment
//                                 //         .center,
//                                 children: [
//                                   SizedBox(width: 20),
//                                   Text(
//                                     "Order Details".toUpperCase(),
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins-Bold',
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             // ),
//                             SizedBox(height: 20),
//                             Container(
//                               margin:
//                                   EdgeInsets.only(left: 20, right: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins-Bold',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textAlign: TextAlign.left,
//                                       "Order Id"),
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textDirection: TextDirection.ltr,
//                                       textAlign: TextAlign.right,
//                                       "${orderList[index]["order_id"]}"),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin:
//                                   EdgeInsets.only(left: 20, right: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins-Bold',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textAlign: TextAlign.left,
//                                       "Product"),
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textDirection: TextDirection.ltr,
//                                       textAlign: TextAlign.right,
//                                       "${orderList[index]["cart_items"][0]["product_name"]}"),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin:
//                                   EdgeInsets.only(left: 20, right: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins-Bold',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textAlign: TextAlign.left,
//                                       "Amount"),
//                                   Text(
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins',
//                                         fontSize: 13,
//                                         // color: Colors.white,
//                                       ),
//                                       textDirection: TextDirection.ltr,
//                                       textAlign: TextAlign.right,
//                                       "₹ ${orderList[index]["total"]}"),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                                 margin: EdgeInsets.only(
//                                     left: 20, right: 20),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Bold',
//                                           fontSize: 13,
//                                           // color: Colors.white,
//                                         ),
//                                         textAlign: TextAlign.left,
//                                         "Quantity"),
//                                     Text(
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontSize: 13,
//                                           // color: Colors.white,
//                                         ),
//                                         textDirection:
//                                             TextDirection.ltr,
//                                         textAlign: TextAlign.right,
//                                         "${orderList[index]["cart_items"][0]["quantity"]} Kg"),
//                                   ],
//                                 )),
//                             Container(
//                                 margin: EdgeInsets.only(
//                                     left: 20, right: 20),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Bold',
//                                           fontSize: 13,
//                                           // color: Colors.white,
//                                         ),
//                                         textAlign: TextAlign.left,
//                                         "Payment Status"),
//                                     Text(
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontSize: 13,
//                                           // color: Colors.white,
//                                         ),
//                                         textDirection:
//                                             TextDirection.ltr,
//                                         textAlign: TextAlign.right,
//                                         "${orderList[index]["payment_status"]}"),
//                                   ],
//                                 )),
//                             SizedBox(height: 20)
//                           ],
//                         ),
//                       ),
//                     ));
//               })
//     ],
//   )),
// ),
