import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:skiki_blog/components/CategoryListItem.dart';
import 'package:skiki_blog/components/RecentPostItem.dart';
import 'package:skiki_blog/components/TopPostCard.dart';
import 'package:skiki_blog/components/CategoryListItem.dart';
import 'package:skiki_blog/page/Login.dart';
import 'package:skiki_blog/page/aboutUs.dart';
import 'package:skiki_blog/page/contactUs.dart';
import 'package:skiki_blog/page/dashboard.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: MyHomePage(),
      home: Dashboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final name;
  final email;
  MyHomePage({this.name = "Guest", this.email = ""});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var curdate = DateFormat("d MMMM y").format(DateTime.now());

  List searchList = [];

  Future<void> showALLPost() async {
    var url =
        Uri.parse("http://localhost/sKiki_blog_flutter/uploads/postAll.php");

    try {
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        for (var i = 0; i < jsonData.length; i++) {
          searchList.add(jsonData[i]['title']);
        }
        print(searchList);
        // print(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showALLPost();
  }

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
            onTap: () {},
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
            leading: Icon(Icons.info),
            title: Text(
              "About us",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUs()));
            },
            leading: Icon(Icons.phone_forwarded),
            title: Text(
              "Contact Us",
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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 10),
              // child: SizedBox(
              //   width: 150,
              //   height: 50,
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       labelText: "Search",
              //       prefixIcon: Icon(
              //         Icons.search,
              //         color: Colors.grey,
              //       ),
              //     ),
              //   ),
              // ),

              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: searchPost(list: searchList));
                    // SizedBox(
                    //   width: 150,
                    //   height: 50,
                    //   child: const TextField(
                    //     decoration: InputDecoration(
                    //       labelText: "Search",
                    //       prefixIcon: Icon(
                    //         Icons.search,
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // );
                  }))
        ],
      ),
      drawer: menuDrawer(),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Blog posts",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  curdate,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      color: Colors.grey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.today, color: Colors.pink),
              ),
            ],
          ),
          const TopPostCard(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              child: Text(
                "Top categories",
                style: TextStyle(fontSize: 25, fontFamily: "FontSans"),
              ),
            ),
          ),
          const Categorylistitem(),
          const RecentPostItem()
        ],
      ),
    );
  }
}

class searchPost extends SearchDelegate {
  List<dynamic> list;
  searchPost({required this.list});

  List searchTitle = [];

  Future<void> showALLPost() async {
    var url =
        Uri.parse("http://localhost/sKiki_blog_flutter/uploads/searchPost.php");

    try {
      var response = await http.post(url,
          body: {"title": query}).timeout(const Duration(seconds: 10));

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);

        print(searchTitle);
        print(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: showALLPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            
            return ListView.builder(
              
                itemCount: snapshot.data.length,
                
                itemBuilder: (context, index) {
                  var list = snapshot.data[];
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(list['title']),
                    ),
                  ]);
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listData = query.isEmpty
        ? list // Show the entire list if the query is empty
        : list
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Display appropriate message or suggestions
    return listData.isEmpty
        ? const Center(
            child: Text("No matching results found."),
          )
        : ListView.builder(
            itemCount: listData.length, // Use the correct filtered list length
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listData[index]),
                onTap: () {
                  query = listData[index]; // Update query to the selected item
                  showResults(context); // Trigger buildResults
                },
              );
            },
          );
  }
}
