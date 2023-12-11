import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/model/cartModel.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'model/subscriptionModel.dart';

void main() async {
// const kWebRecaptchaSiteKey = 'DCDC755E-2657-412D-9D89-08A87F1DA589';
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await FirebaseAppCheck.instance.activate(
    //  androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.debug,
    // webRecaptchaSiteKey: 'DCDC755E-2657-412D-9D89-08A87F1DA589',
   );
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FirebaseMessaging.instance.getToken()
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    print("message recieved");
    print(event.notification!.body);
    
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SafeArea(
          child: ListTile(
            minVerticalPadding: 20,
            // leading: SizedBox.fromSize(
            //     size: const Size(40, 40),
            //     child: ClipOval(
            //         child: Container(
            //       color: Colors.transparent,
            //     ))),
            title: Text('Notification'),
            subtitle: Text('${event.notification!.body}'),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));
    // showSimpleNotification(
    //   Text("${event.notification!.body}"),
    //   background: Colors.purple,
    //   autoDismiss: false,
    //   trailing: Builder(builder: (context) {
    //     return FlatButton(
    //         textColor: Colors.yellow,
    //         onPressed: () {
    //           OverlaySupportEntry.of(context)!.dismiss();
    //         },
    //         child: Text('Dismiss'));
    //   }),
    // );
    // await processNotification(event, context);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
  runApp(MyApp(model: CartModel(), models: SubscriptionModel()));
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final CartModel model;
  final SubscriptionModel models;

  const MyApp({Key? key, required this.model, required this.models})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: ScopedModel<SubscriptionModel>(
            model: models,
            child: ScopedModel<CartModel>(
              model: model,
              child: MaterialApp(
                theme: ThemeData(fontFamily: 'Poppins'),
                home: MyHomePage(),
                debugShowCheckedModeBanner: false,
              ),
            )));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () async {
      final prefManager = await SharedPreferences.getInstance();
      bool status = prefManager.getBool(Constant.KEY_IS_LOGIN) ?? false;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  status == true ? DashBoard() : DashBoard()));
    });

    messaging.getToken().then((value) async {
      final prefManager = await SharedPreferences.getInstance();
      prefManager.setString(Constant.KEY_DEVICE_TOKEN, value!);
      print(value);
      print("Device Token: $value");
    });
    messaging.onTokenRefresh.listen((fcmToken) async {
      final prefManager = await SharedPreferences.getInstance();
      prefManager.setString(Constant.KEY_DEVICE_TOKEN, fcmToken);
      print(fcmToken);
    }).onError((err) {
      // Error getting token.
      print(err);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  processNotification(message, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notification"),
            content: Text(message.notification!.body!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Constant.Splash_Screen_Background),
              fit: BoxFit.cover),
        ));
  }
}



// ??  MainActivity.kt file
//
//
// package com.avigna.maati

//  import io.flutter.embedding.android.FlutterActivity
//     import android.os.Bundle
//     import com.google.firebase.FirebaseApp
//     import com.google.firebase.appcheck.FirebaseAppCheck;
//     import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
    
    
// class MainActivity: FlutterActivity() {
//  override fun onCreate(savedInstanceState: Bundle?) {
//         FirebaseApp.initializeApp(/*context=*/this)
//         val firebaseAppCheck = FirebaseAppCheck.getInstance()
//         firebaseAppCheck.installAppCheckProviderFactory(
//             DebugAppCheckProviderFactory.getInstance()
//         )
//         super.onCreate(savedInstanceState)
//     }
// } 