import 'package:dhurmaati/screens/cart_screen.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/main_profile.dart';
import 'package:dhurmaati/screens/wishlist_screen.dart';
import 'package:dhurmaati/widget/bottomnavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

import '../Constants/constants.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
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
    // getdata() {
    // getDashBoard(context);
    // getPosts(context);
    // getDetails(context);
    // }
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
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 253, 250, 219),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: Stack(children: [
              Container(
                alignment: Alignment.center,
                width: 340,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Thank You!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Your order has been placed Successfully,",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "You will recieve the receipt shortly.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset("assets/images/thankyou.png",
                        width: 150, height: 150)
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  height: 60,
                  width: 340,
                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // color: Color.fromARGB(255, 193, 63, 41),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    onPressed: () async {
                      // isNewUser
                      //     ? () {}
                      //     :
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => DashBoard()),
                          (route) => false);
                      // setState(() {
                      //   isNewUser = false;
                      // });
                    },
                    child: Text('Back To Shop',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              )
            ]))),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedScreenIndex,
          onClicked: _selectScreen,
        ),
      ),
    );
  }
}
