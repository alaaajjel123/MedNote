import 'package:flutter/material.dart';
import 'package:node_app_conn/dashboard.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade900,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      home: (token != null && !JwtDecoder.isExpired(token!))
          ? Dashboard(token: token!)
          : SignInPage(),
    );
  }
}
