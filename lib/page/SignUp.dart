import 'package:flutter/material.dart';
import 'package:skiki_blog/page/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController name = TextEditingController();

  // Function to show AlertDialog
  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost/sKiki_blog_flutter/uploads/register.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name.text,
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var responseData = convert.jsonDecode(response.body);

      // Check if there is an error message
      if (responseData['error'] != null) {
        showAlertDialog(context, "Error", responseData['error']);
      } else if (responseData['success'] != null) {
        // Show success message and navigate to login
        showAlertDialog(context, "Success", "User registered successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      showAlertDialog(context, "Error", "Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Sign Up Page"),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
            ),
            Positioned(
              top: 100,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: 'FontSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ),
            Positioned(
              top: 140,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: name, // Link controller to capture username
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                  )),
            ),
            Positioned(
              top: 200,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: user, // Link controller to capture username
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  )),
            ),
            Positioned(
              top: 260,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: pass, // Link controller to capture password
                      obscureText: true, // Hide password input
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                  )),
            ),
            Positioned(
              top: 320,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: confirmPass, // Capture confirm password
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: "Confirm Password"),
                    ),
                  )),
            ),
            Positioned(
              top: 400,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.pink,
                        onPressed: () {
                          // Check if the password and confirm password match
                          if (user.text.isEmpty ||
                              pass.text.isEmpty ||
                              confirmPass.text.isEmpty) {
                            // Show an error dialog
                            showAlertDialog(
                                context, "Error", "All fields are required.");
                          } else if (pass.text != confirmPass.text) {
                            // Show a password mismatch error dialog
                            showAlertDialog(
                                context, "Error", "Passwords do not match.");
                          } else {
                            // Register user if validation passes
                            registerUser(user.text, pass.text);
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 20),
                        ),
                      ))),
            ),
            Positioned(
              top: 460,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Already have an account?")),
              ),
            ),
            Positioned(
              top: 460,
              left: 160,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 10, right: 10, bottom: 8.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "Click here to Login",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
