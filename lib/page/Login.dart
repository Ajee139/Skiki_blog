import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skiki_blog/main.dart';
import 'dart:convert' as convert;
import 'package:skiki_blog/page/SignUp.dart';
import 'package:skiki_blog/page/dashboard.dart';
// Import your homepage or the screen to navigate to after login success

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  // Method to handle login request
  Future<void> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/sKiki_blog_flutter/uploads/login.php'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse.containsKey('error')) {
          // Show an alert dialog for an error (e.g. invalid credentials)
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(jsonResponse['error']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (jsonResponse.containsKey('message')) {
          // Show success and navigate to the homepage on successful login
          if (jsonResponse.containsKey('error')) {
            // Show error dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(jsonResponse['error']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Close dialog
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (jsonResponse.containsKey('message')) {
            // Navigate to appropriate page without showing a dialog
            if (jsonResponse['status'] == 'admin') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            } else {
              if (jsonResponse['status'].toString() == "user") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                            name: jsonResponse['name'],
                            email: jsonResponse['email'])));
              }
              debugPrint(jsonResponse['user'].toString());
              debugPrint(jsonResponse['status'].toString());
            }
          }
        }
      } else {
        // Handle any other response code
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to login. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle errors (e.g. network errors)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Login Page"),
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
                  "Login",
                  style: TextStyle(
                      fontFamily: 'FontSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ),
            Positioned(
              top: 200,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: user, // Username input controller
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
                      controller: pass, // Password input controller
                      obscureText: true, // Hide password input
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                  )),
            ),
            Positioned(
              top: 350,
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
                          // Perform login when the button is pressed
                          if (user.text.isEmpty || pass.text.isEmpty) {
                            // Show alert if fields are empty
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('All fields are required'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            loginUser(
                                user.text, pass.text); // Call login method
                          }
                        },
                        child: Text(
                          "Login",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 20),
                        ),
                      ))),
            ),
            Positioned(
              top: 410,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Don't have an account?")),
              ),
            ),
            Positioned(
              top: 410,
              left: 150,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 10, right: 10, bottom: 8.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          "Click here to Sign Up",
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
