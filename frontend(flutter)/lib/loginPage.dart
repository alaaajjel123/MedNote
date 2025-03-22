import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:node_app_conn/dashboard.dart';
import 'package:node_app_conn/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _obscurePassword = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        setState(() {
          _isNotValidate = true;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CommonLogo(),
                    SizedBox(height: 20),
                    "Email Sign-In".text.xl2.bold.white.make(),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                        errorText: _isNotValidate
                            ? "Enter valid Email & Password"
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ).p4(),
                    SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ).p4(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.deepPurple.shade500,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registration()));
                      },
                      child: "Create a new Account..! Sign Up"
                          .text
                          .xl
                          .semiBold
                          .white
                          .underline
                          .make(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
