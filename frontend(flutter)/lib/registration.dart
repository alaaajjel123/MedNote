import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        print("Registration successful");
      } else {
        print("Something went wrong");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF145AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CommonLogo(),
                SizedBox(height: 20),
                "Create Your Account".text.size(22).white.bold.make(),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _isNotValidate ? "Enter a valid email" : null,
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ).py12(),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _isNotValidate ? "Enter a valid password" : null,
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: passwordController.text));
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ).py12(),
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: "Register".text.color(Colors.blue).bold.make(),
                ).py16(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: "Already Registered? Sign In"
                      .text
                      .white
                      .bold
                      .makeCentered()
                      .py12(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#\$%^&*()<>,./';
  return List.generate(20, (index) => chars[Random().nextInt(chars.length)])
      .join();
}
