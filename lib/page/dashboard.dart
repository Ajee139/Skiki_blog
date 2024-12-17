import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:skiki_blog/admin/categoryDetails.dart';
import 'package:skiki_blog/admin/postDetails.dart';
import 'package:skiki_blog/components/CategoryListItem.dart';
import 'package:skiki_blog/components/RecentPostItem.dart';
import 'package:skiki_blog/components/TopPostCard.dart';

import 'package:skiki_blog/main.dart';
import 'package:skiki_blog/page/Login.dart';
import 'package:skiki_blog/page/aboutUs.dart';
import 'package:skiki_blog/page/contactUs.dart';
import 'package:skiki_blog/page/postDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  final name;
  final email;
  Dashboard({this.name = 'Guest', this.email = ''});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Widget menuDrawer() {
      return Drawer(
        child: ListView(children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              accountName: Text(widget.name),
              accountEmail: Text(widget.email)),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Categorydetails()));
            },
            leading: Icon(Icons.info),
            title: Text(
              "Add Category",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Postdetails(author: widget.name)));
            },
            leading: Icon(Icons.phone_forwarded),
            title: Text(
              "Add post",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          widget.name == "Guest"
              ? ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  leading: Icon(Icons.login),
                  title: Text(
                    "Login",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              : ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  leading: Icon(Icons.lock_open, color: Colors.red),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
        ]),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Dashboard")),
        ),
        drawer: menuDrawer(),
        body: ListView(
          children: [MyGridView()],
        ));
  }

  Widget MyGridView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 250,
          child: GridView.count(
            crossAxisSpacing: 5,
            crossAxisCount: 2,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple),
                // color: Colors.purple,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Total post: 10000",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "FontSans"),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                // color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Total Category: 15",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "FontSans"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
