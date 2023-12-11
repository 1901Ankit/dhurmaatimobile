import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future addUser(BuildContext context, String title) async {
  // final connectivityResult = await (Connectivity().checkConnectivity());
  // print(connectivityResult);
  // print(">>>>>>>connectivity");
  // if (connectivityResult == ConnectivityResult.none) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         width: 300,
  //         height: 300,
  //         child: AlertDialog(
  //           title: Text(
  //             'No Internet Connection',
  //             style: TextStyle(fontFamily: 'Poppins-Bold'),
  //           ),
  //           content: Text(
  //             'You are not connected to the internet. To view the page, please join a network.',
  //             style: TextStyle(fontFamily: 'Poppins'),
  //           ),
  //           actions: [
  //             FlatButton(
  //               textColor: Colors.black,
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'CANCEL',
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                 ),
  //               ),
  //             ),
  //             FlatButton(
  //               textColor: Colors.black,
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'YES',
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // } else {
  print('${Constant.KEY_URL}');
  print(title);
  final response = await http.post(
    Uri.parse('${Constant.KEY_URL}/api/send-otp'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'phone_number': title,
    }),
  );

  if (response.statusCode == 200) {
    // print("dnfcdfmd $title");
    var data = jsonDecode(response.body);

    var rest = data["response"];
    var message1 = rest["message"];
    print(data);
    print(message1);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VerifyOTP(title)));
    // return Album.fromJson(jsonDecode(response.body));
    Fluttertoast.showToast(
      msg: "$message1",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else if (response.statusCode > 200) {
    var data = jsonDecode(response.body);

    var rest = data["response"];
    var message1 = rest["message"];
    print(data);
    print(message1);
    Fluttertoast.showToast(
      msg: "$message1",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    Fluttertoast.showToast(
      msg: "Internal Server Error Please try again",
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

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();

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
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // The child of a round Card should be in round shape
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Container(
                        child: Image.asset("assets/images/maatilogo.png"),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                  )),
              // Container(
              //   margin: EdgeInsets.only(top: 30),
              //   child: Center(
              //     child: Text(
              //       'Welcome',
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //           color: Colors.red),
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'Welcome to Dhur Maati App',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, right: 30, left: 30),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      prefixIcon: Icon(
                        Icons.tablet_android_sharp,
                        color: Colors.green,
                      ),
                      suffixIcon: Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _controller,
                  cursorColor: Colors.green,
                ),
              ),
              Container(
                  height: 60,
                  width: 383,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 30, right: 10, left: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ))),
                    child: const Text(
                      'Send OTP',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => VerifyOTP(_controller.text)));
                      setState(() {
                        addUser(context, _controller.text);
                      });
                    },
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
