import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/custom_alert_notifer_controller.dart';
import 'controllers/handler_call_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/users_controller.dart';
import 'pages/callkeep.dart';

const appId = "f4f34ce4ca1343b884337cb5d5355e03";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(LoginController());
  Get.put(UsersController());
  Get.put(CustomAlertNotifierController());
  Get.put(HandlerCallController());

  // HttpOverrides.global = MyHttpOverrides();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isUserLogin = prefs.getBool('isUserLogin');
  var isFirstTime = prefs.getBool('isFirstTime');
  runApp(MyApp(isUserLogin: isUserLogin, isFirstTime: isFirstTime));
  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({required this.isUserLogin, required this.isFirstTime});
  late var isUserLogin;
  late var isFirstTime;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: widget.isFirstTime == null
      home: widget.isFirstTime != null
          ? const OnBoardingScreen()
          : MyHomePage(isUserLogin: widget.isUserLogin),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.isUserLogin}) : super(key: key);
  late var isUserLogin;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (widget.isUserLogin != null) ? Nav() : LoginPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}
