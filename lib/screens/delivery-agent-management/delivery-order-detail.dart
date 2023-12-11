import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dhurmaati/screens/customer-order-management/customer_order_list.dart';
import 'package:dhurmaati/screens/delivery-agent-management/delivery-order-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../../widget/appBarDrawer.dart';
import '../../widget/appBarTitle.dart';
import '../../widget/bottomnavigation.dart';
import '../cart_screen.dart';
import '../main_dashboard_page.dart';
import '../main_profile.dart';
import '../wishlist_screen.dart';
import 'package:dhurmaati/screens/orders_screen.dart';

class DeliveryOrderDetailsPage extends StatefulWidget {
  final List orders;

  DeliveryOrderDetailsPage(this.orders);

  @override
  State<DeliveryOrderDetailsPage> createState() =>
      _DeliveryOrderDetailsPageState();
}

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class _DeliveryOrderDetailsPageState extends State<DeliveryOrderDetailsPage> {
  int _selectedScreenIndex = 0;

  late List _screens;
  int _value = 1;
  int? _values;
  bool showQR = false;
  @override
  initState() {
    _screens = [
      {"screen": DashBoard(), "title": "DashBoard"},
      {"screen": CartPage(), "title": "Cart"},
      {"screen": OrdersList(), "title": "Orders"},
      {"screen": MyProfile(), "title": "My Account"}
    ];
    loadCamera();
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

  Future addDeliveryStatus(int order_id) async {
    final prefManager = await SharedPreferences.getInstance();
    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    final response = await http.patch(
      Uri.parse('${Constant.KEY_URL}/api/update-order-status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $login_token',
      },
      body: jsonEncode({"order_id": order_id}),
    );
    if (response.statusCode == 200) {
      // print("dnfcdfmd $title");
      var res = jsonDecode(response.body);
      var resp = res["response"];
      var message = resp["message"];

      print(message);

      Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeliveryOrdersList()),
      );

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

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  bool showimg = true;
  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  // File? image;
  bool _isAcceptTermsAndConditions = true;

  // pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera);

  //     if (image == null) return;

  //     final imageTemp = File(image.path);

  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  Future CompleteProfile(
    BuildContext context,
    // String login_token,
    XFile? imagefile,
    bool name,
    int number,
  ) async {
    final prefManager = await SharedPreferences.getInstance();

    String? login_token = prefManager.getString(Constant.KEY_LOGIN_TOKEN);
    String? group = prefManager.getString(Constant.KEY_USER_GROUP);
    print(group);
    Map<String, String> headers = {'Authorization': 'Bearer $login_token'};
    var req = http.MultipartRequest(
        'PATCH', Uri.parse('${Constant.KEY_URL}/api/update-order-status'));
    req.fields['order_id'] = number.toString();

    req.fields['payment_method'] = number == true ? "COD" : "QR";

    req.headers.addAll(headers);
    // print(profession);
    if (imagefile != null) {
      req.files.add(http.MultipartFile.fromBytes(
          'file', File(imagefile.path).readAsBytesSync(),
          filename: imagefile.path));
    }
    var respo = await req.send();
    if (respo.statusCode == 200) {
      // var res = respo.body;
      var res = await http.Response.fromStream(respo);
      final result = jsonDecode(res.body);
      var rest = result["response"];
      var message1 = rest["message"];
      // print(data);
      print(message1);
      print(res);
      print(result);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeliveryOrdersList()),
      );
      Fluttertoast.showToast(
        msg: "$message1",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (respo.statusCode > 200) {
      var res = await http.Response.fromStream(respo);
      var data = jsonDecode(res.body);

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
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "   Order items ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.orders[0]["cart_items"].length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = widget.orders[0]["cart_items"][index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Card(
                        child: Row(
                          children: [
                            Image.network(
                              '${order["image_url"]}',
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product: ${order["product_name"]}'),
                                Text(
                                    'OrderId: #${widget.orders[0]["order_id"]}'),
                                Text('Quantity: ${order["quantity"]} Package'),
                                Text('Price: ₹${widget.orders[0]["total"]}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Details'),
                        SizedBox(height: 8.0),
                        Text('Name: ${widget.orders[0]["users"]["name"]}'),
                        Text(
                            'Contact Number: ${widget.orders[0]["users"]["contact_no"]}'),
                        Text(
                            'Address: ${widget.orders[0]["users"]["address1"]}'),
                        Text('City: ${widget.orders[0]["users"]["city"]}'),
                        Text('State: ${widget.orders[0]["users"]["state"]}'),
                        Text('Pin Code : ${widget.orders[0]["users"]["pin"]}'),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showQR = !showQR;
                  });
                },
                child: Text(
                  showQR ? "Hide QR Code " : "Show QR Code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 16),
                ),
              ),
              showQR
                  ? SizedBox(
                      height: 10,
                    )
                  : new Container(),
              showQR
                  ? Container(
                      margin: EdgeInsets.all(20.0),
                      child: Image(
                        image: CachedNetworkImageProvider(
                            "https://dhurmaati.s3.ap-southeast-1.amazonaws.com/qr.jpeg"),
                      ))
                  : new Container(),
              showQR
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Upload Transaction Image :"),
                        // IconButton(
                        //   onPressed: () {
                        //     pickImage();
                        //   },
                        //   color: Colors.green,
                        //   iconSize: 50,
                        //   icon: Icon(Icons.camera_alt),
                        // ),
                      ],
                    )
                  : new Container(),
              showQR
                  ? Container(
                      margin: EdgeInsets.all(20),
                      height: 500,
                      // width: 300,
                      child: showimg == false
                          ? showimage(image: image)
                          : controller == null
                              ? Center(child: Text("Loading Camera..."))
                              : !controller!.value.isInitialized
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CameraPreview(controller!))
                  : new Container(),
              showQR
                  ? Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 193, 63, 41)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        icon: Icon(Icons.camera),
                        label: Text(
                          showimg == false ? "Retake" : 'Capture',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            if (controller != null) {
                              //check if contrller is not null
                              if (controller!.value.isInitialized) {
                                //check if controller is initialized
                                image = await controller!.takePicture();
                                //capture image
                                // ignore: use_build_context_synchronously
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PreviewPage(
                                //               picture: image!,
                                //             )));
                                setState(() {
                                  showimg = false;
                                  //update UI
                                  print(image);
                                  print(showimg);
                                });
                              }
                            }
                          } catch (e) {
                            print(e); //show error
                          }
                        },
                      ))
                  : new Container(),
              // ElevatedButton.icon(
              //   //image capture button
              //   onPressed: () async {
              //     try {
              //       if (controller != null) {
              //         //check if contrller is not null
              //         if (controller!.value.isInitialized) {
              //           //check if controller is initialized
              //           image = await controller!.takePicture();
              //           //capture image
              //           // ignore: use_build_context_synchronously
              //           // Navigator.push(
              //           //     context,
              //           //     MaterialPageRoute(
              //           //         builder: (context) => PreviewPage(
              //           //               picture: image!,
              //           //             )));
              //           setState(() {
              //             showimg = false;
              //             //update UI
              //             print(image);
              //             print(showimg);
              //           });
              //         }
              //       }
              //     } catch (e) {
              //       print(e); //show error
              //     }
              //   },
              //   icon: Icon(Icons.camera),
              //   label: Text("Capture"),
              // ),

              // showQR
              //     ? Container(
              //         //show captured image
              //         padding: EdgeInsets.all(30),
              //         child: showimg == false
              //             ? showimage(image: image)
              //             : new Container(),
              //         //display captured image
              //       )
              //     : new Container(),
              // Center(
              //   child: image != null
              //       ? Image.file(image!)
              //       : Text("No image selected"),
              // ),
              Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 193, 63, 41)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child: const Text(
                      'Set Order to Delivered',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {
                      CompleteProfile(
                          context, image, showQR, widget.orders[0]["order_id"]);
                      // addDeliveryStatus(widget.orders[0]["order_id"]);
                    },
                  )),

              SizedBox(
                height: 20,
              ),
            ],
          )),
          bottomNavigationBar: BottomMenu(
            selectedIndex: _selectedScreenIndex,
            onClicked: _selectScreen,
          ),
        ));
  }
}
