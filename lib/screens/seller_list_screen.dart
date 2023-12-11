import 'dart:convert';
import 'dart:io';
import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/login_screen.dart';
import 'package:dhurmaati/screens/seller_screen.dart';
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

class SellarListDetailPage extends StatefulWidget {
  final Product product;

  const SellarListDetailPage(this.product, {Key? key}) : super(key: key);

  @override
  State<SellarListDetailPage> createState() => _SellarListDetailPageState();
}

class _SellarListDetailPageState extends State<SellarListDetailPage>
    with SingleTickerProviderStateMixin {
  @override
  initState() {
    getDetails(context);
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
  List<dynamic> notificationList = [];

  Future getDetails(BuildContext context) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    print(login_token);

    final response = await http.post(
        Uri.parse('${Constant.KEY_URL_ACF}/api/get-farms-contact_no'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'contact_no': widget.product.user?.contact_no}));//// "9167102936"

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      print(res);
      var respon = res["response"];
      setState(() {
        notificationList = respon["message"];

      });
      notificationList = respon["message"];

      // notificationList = message;

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
        msg: "Internal Server Error Please try again",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // setState(() {
      //   isNewUser = true;
      // });
      throw Exception('Failed to create album.');
    }
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
            "Farms List".toUpperCase(),
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          child:  notificationList.isEmpty
              ? Center(
            child: Text("Farmers not available"),
          )
              : ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, position) {
              return GestureDetector(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellarDetailPage(
                                      notificationList[position])),
                            )
                          },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(18), // Image radius
                                  child: Image.network(
                                      notificationList[position]["users"]
                                          ["avatar"],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${notificationList[position]["users"]["name"] +" ("+capitalizeAllWord(
                                  notificationList[position]["crop"]
                              ) +" Farm)" }",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ));
            },
          ),
        ),
      ),
    );
  }
}
