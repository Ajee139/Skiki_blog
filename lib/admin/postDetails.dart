import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:skiki_blog/admin/addeditPost.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Postdetails extends StatefulWidget {
  final String author; // Define the author property

  const Postdetails({Key? key, required this.author}) : super(key: key);

  @override
  State<Postdetails> createState() => _PostdetailsState();
}

class _PostdetailsState extends State<Postdetails> {
  List post = [];

  Future getAllPost() async {
    var url = Uri.parse(
        "http://localhost/sKiki_blog_flutter/uploads/postAll.php"); // Correct URL

    try {
      var response = await http.post(url, body: {}); // Correct body

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);

        setState(() {
          post = jsonData;
        });

        print(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addEditPost(author: widget.author),
                ),
              ).whenComplete(() {
                getAllPost();
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Card(
              elevation: 2,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => addEditPost(
                          postList: post,
                          index: index,
                          author: widget.author,
                        ),
                      ),
                    ).whenComplete(() {
                      getAllPost();
                    });
                  },
                ),
                title: Text(post[index]["title"]),
                subtitle: Text(post[index]["body"], maxLines: 2),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Message'),
                          content: Text('Are you sure you want to delete?'),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.green)),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  var url = Uri.parse("http://localhost/sKiki_blog_flutter/uploads/postAll.php");
                                  var response = await http.post(url,
                                      body: {"id": post[index]['id']});
                                  if (response.statusCode == 200) {
                                    Fluttertoast.showToast(
                                        msg: "Post added successfully",
                                        fontSize: 20);
                                    setState(() {
                                      getAllPost();
                                    });
                                  }
                                },
                                child: Text('Confirm')),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
