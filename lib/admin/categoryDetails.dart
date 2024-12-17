import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:skiki_blog/admin/addEditCategory.dart';

class Categorydetails extends StatefulWidget {
  const Categorydetails({super.key});

  @override
  State<Categorydetails> createState() => _CategorydetailsState();
}

class _CategorydetailsState extends State<Categorydetails> {
  List category = [];
  Future getAllCategory() async {
    var url = Uri.parse(
        "http://localhost/sKiki_blog_flutter/uploads/categoryAll.php"); // Correct URL

    try {
      var response = await http.post(url, body: {}); // Correct body

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);

        setState(() {
          category = jsonData;
        });

        print(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // Call getAllCategoryPost when widget is initialized
  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Details"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addeditcategory()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
          child: ListView.builder(
              itemCount: category.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Addeditcategory(
                                      categoryList: category, index: index)));
                        },
                        icon: Icon(Icons.edit)),
                    title: Text(category[index]['name']),
                    trailing: IconButton(
                        onPressed: () async {
                          var url = Uri.parse(
                              'http://localhost/sKiki_blog_flutter/uploads/deleteCategory.php');
                          var response = await http
                              .post(url, body: {"id": category[index]["id"]});
                          if (response.statusCode == 200) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Message'),
                                  content: Text('Category delete Successful'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        icon: Icon(Icons.delete)),
                  ),
                );
              })),
    );
  }
}
