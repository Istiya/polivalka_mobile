import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polivalka/pages/home_page.dart';
import 'package:polivalka/pages/registration_page.dart';
import 'package:polivalka/util/http_util.dart';
import 'pages/login_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: Center(
        child: CircularProgressIndicator(),
      ),
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      title: 'Polivalka',
      initialRoute: await HttpUtil.loginByToken() == 401 ? '/login' : '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/registration': (context) => const RegistrationPage(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.adventProTextTheme(),
      ),
    ),
  );
}
