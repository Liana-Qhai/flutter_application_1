// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/helper/helper_function.dart';
import 'package:flutter_application_1/pages/auth/login_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize firebase from firebase core plugin

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  String? dToken = " ";

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    // init();
    requestPermission();
    getToken();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

//when sending notifications it need to authorized the specific user logged in
 void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined and has not accepted permission');
    }
  }

  //getting the firebase device token
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        dToken = token;
        print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ###### is $dToken");
      });
      saveToken(token!);
    });
  }

  //save the firebase device token in the firestore
  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("Device Token").doc("FCM_ID").set({
      'token': token,
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }

}

  // init() async {
  //   String deviceToken = await getDeviceToken();
  //   print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCATION ######");
  //   print(deviceToken);
  //   print("############################################################");

  //   // listen for user to click on notification 
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
  //     String? title = remoteMessage.notification!.title;
  //     String? description = remoteMessage.notification!.body;

  //     //im gonna have an alertdialog when clicking from push notification
  //     Alert(
  //       context: context,
  //       type: AlertType.error,
  //       title: title, // title from push notification data
  //       desc: description, // description from push notifcation data
  //       buttons: [
  //         DialogButton(
  //           onPressed: () => Navigator.pop(context),
  //           width: 120,
  //           child: const Text(
  //             "COOL",
  //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //         )
  //       ],
  //     ).show();
  //   });
    
  // }

  //  //for getting firebase messaging device token to use (push notification)
  // Future getDeviceToken() async {

  //   //request user permission for push notification 
  //   FirebaseMessaging.instance.requestPermission();
  //   FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
  //   String? deviceToken = await firebaseMessage.getToken();
  //   return (deviceToken == null) ? "" : deviceToken;
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((deviceToken) {
  //     setState(() {
  //       deviceToken = deviceToken;
  //       print("###### PRINT FCM TOKEN TO USE FOR PUSH NOTIFCIATION ###### is $deviceToken");
  //     });
  //     savedeviceToken(deviceToken!);
  //   });
  // }
  // void savedeviceToken(String deviceToken) async {
  //     await FirebaseFirestore.instance.collection("Device Token").doc("FCM ID").set({
  //       'Device Token': deviceToken,
  //     });
  // }


