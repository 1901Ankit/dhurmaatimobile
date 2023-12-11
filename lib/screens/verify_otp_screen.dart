import 'dart:convert';

import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTP extends StatefulWidget {
  // const VerifyOTP({Key? key}) : super(key: key);
  final String phone;
  VerifyOTP(this.phone);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  var login_token;
  final int time = 30;
  late AnimationController _controller;
  // late Timer timer;
  late int totalTimeInSeconds;

  bool _hideResendButton = false;
  bool isShowLoader = false;
  String? uid;
bool _isAcceptTermsAndConditions = true;
  // final defaultPinTheme = PinTheme(
  //   width: 56,
  //   height: 56,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: Color.fromRGBO(30, 60, 87, 1),
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Colors.black),
  //     borderRadius: BorderRadius.circular(20),
  //   ),
  // );

  Future verifyUID(BuildContext context, String number, String uid) async {
    final prefManager = await SharedPreferences.getInstance();
    print(uid);
    print(number);
    String? token = prefManager.getString(Constant.KEY_DEVICE_TOKEN);
    final response = await http.post(
      Uri.parse('${Constant.KEY_URL}/api/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode({'phone_number': number, 
          // 'uid': uid,
          'otp':uid, 
          "device_token": token}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      var rest = data["response"];
      var message1 = rest["message"];

      login_token = message1["login_token"];
      var group = message1["group_name"];
      var user_id = message1["user_id"];
      prefManager.setString(Constant.KEY_LOGIN_TOKEN, login_token);
      prefManager.setBool(Constant.KEY_IS_LOGIN, true);
      prefManager.setString(Constant.KEY_USER_GROUP, group);
      prefManager.setInt(Constant.KEY_USER_ID, user_id);
      // String? tk = prefManager.getString(Constant.KEY_LOGIN_TOKEN);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
          (route) => false);

      Fluttertoast.showToast(
        msg: "Successfully Logged In",
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
  }

  @override
  void initState() {
    super.initState();
    // _verifyPhone();
    totalTimeInSeconds = time;
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        key: _scaffoldkey,
        // appBar: AppBar(
        //   title: Text('OTP Verification'),
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          child: Image.asset("assets/images/ic_ms.png"),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      Details.OTP_Verification.toUpperCase(),
                      style: TextStyle(
                        // context: context,
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // fontSizeDelta: 2,
                        // fontWeightDelta: 3
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      Details.OTP_heading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // context: context,
                        color: Colors.black,
                        // fontWeightDelta: 2,
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "${widget.phone}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // context: context,
                        color: Colors.black,
                        // fontWeightDelta: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Container(
                  margin:
                      EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                  // child: SizedBox(

                  child: TextField(
                    keyboardType: TextInputType.number,

                    // focusNode: mFocusNodeOTP,
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    style: TextStyle(
                      // context: context,
                      color: Colors.black,
                      // fontSizeDelta: 3,
                      // fontWeightDelta: -1
                    ),
                    controller: _pinPutController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(20),
                      // contentPadding: EdgeInsets.only(bottom: 13, left: 3),
                      counterText: "",
                      // focusedBorder: UnderlineInputBorder(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      hintText: "Enter OTP",
                      filled: true,
                      // fillColor: Colors.white,
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    // ),
                  ),
                ),
                // Container(
                // alignment: Alignment.center,
                // margin: EdgeInsets.only(top: 30),
                // padding: EdgeInsets.all(8),
                // child: Text(
                //   "Didn't Recieved OTP?",
                //   style: TextStyle(
                //     // context: context,
                //     fontFamily: 'Poppins',
                //     color: Colors.black,
                //     fontSize: 12,
                //     // fontWeightDelta: 1
                //   ),
                // )),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: _hideResendButton
                      ? InkWell(
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // context: context,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              // fontSizeDelta: 1,
                              // fontWeightDelta: 0
                            ),
                          ),
                          onTap: () {
                            addUser(context, widget.phone);
                            // _verifyPhone();
                             setState(() {
                              _isAcceptTermsAndConditions = true;
                            });
                          },
                        )
                      : OtpTimer(_controller, 30.0, Colors.amber),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 60,
                  width: 383,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // color: Color.fromARGB(255, 193, 63, 41),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ))),
                    onPressed: _isAcceptTermsAndConditions
                        ? 
                        
                        () async {
                           setState(() {
                              _isAcceptTermsAndConditions = false;
                            });
verifyUID(context, widget.phone, _pinPutController.text);
                            
                      // try {
                        
                      //   // await FirebaseAuth.instance.
                      //   await FirebaseAuth.instance
                      //       .signInWithCredential(PhoneAuthProvider.credential(
                      //           verificationId: _verificationCode!,
                      //           smsCode: _pinPutController.text.toString()))
                      //       .then((value) async {
                      //     if (value.user != null) {
                      //       // print("<<<<<<<<<<<<<<<<<<<<<<<<");
                      //       // print(value.user!.uid);
                      //       String uids = value.user!.uid;
                      //       setState(() {
                      //         uid = value.user!.uid;
                      //       });
                      //       // verifyUID(context, widget.phone, uids);
                      //       verifyUID(context, widget.phone, _pinPutController.text);
                      //     }
                      //   });
                      // } catch (e) {
                      //   print(e);
                      //   Fluttertoast.showToast(
                      //     msg: "$e",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.green[400],
                      //     textColor: Colors.white,
                      //     fontSize: 16.0,
                      //   );
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(e.toString())));
                      // }
                      // setState(() {
                      //         _isAcceptTermsAndConditions = false;
                      //       });
                    }:null,
                    child:_isAcceptTermsAndConditions
                        ? const Text('Submit',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)): Center(child:CircularProgressIndicator()),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(30.0),
                //   child: Pinput(
                //     length: 6,
                //     defaultPinTheme: defaultPinTheme,
                //     controller: _pinPutController,
                //     pinAnimationType: PinAnimationType.fade,
                //     onSubmitted: (pin) async {
                //       try {
                //         await FirebaseAuth.instance
                //             .signInWithCredential(PhoneAuthProvider.credential(
                //                 verificationId: _verificationCode!, smsCode: pin))
                //             .then((value) async {
                //           if (value.user != null) {
                //             Navigator.pushAndRemoveUntil(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => ChoiceScreen()),
                //                 (route) => false);
                //             print("bdvshjahddkfsajkds");
                //             print(value);
                //             print(pin);
                //           }
                //         });
                //       } catch (e) {
                //         ScaffoldMessenger.of(context)
                //             .showSnackBar(SnackBar(content: Text(e.toString())));
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
               String uids = value.user!.uid;
                            setState(() {
                              uid = value.user!.uid;
                            });
                            verifyUID(context, widget.phone, uids);

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => ChoiceScreen()),
              //     (route) => false);
              print("hello");
                }
          });
            },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green[400],
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration {
    Duration? duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return new Text(
          timerString,
          // style: AppStyle.textViewStyleNormalButton(
          //     context: context,
          //     color: timeColor,
          //     fontSizeDelta: 1,
          //     fontWeightDelta: 0),
        );
      },
    );
  }
}
