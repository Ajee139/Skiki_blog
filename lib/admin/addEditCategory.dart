import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class Addeditcategory extends StatefulWidget {
  final categoryList;
  final index;
  Addeditcategory({this.categoryList, this.index});

  @override
  State<Addeditcategory> createState() => _AddeditcategoryState();
}

class _AddeditcategoryState extends State<Addeditcategory> {
  TextEditingController categoryNameController = TextEditingController();
  bool editMode = false;

  Future addEditCategory() async {
    if (categoryNameController.text != "") {
      if (editMode) {
        var url = Uri.parse(
            'http://localhost/sKiki_blog_flutter/uploads/updateCategory.php');
        var response = await http.post(url, body: {
          "id": widget.categoryList[widget.index]["id"],
          "name": categoryNameController.text
        });
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Message'),
                content: Text('Category Update Successful'),
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
      }
    } else {
      var url = Uri.parse(
          'http://localhost/sKiki_blog_flutter/uploads/addCategory.php');
      var response = await http.post(url, body: {
        "name": categoryNameController
      });
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Message'),
              content: Text('Category Add Successful'),
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != null) {
      editMode = true;
      categoryNameController.text = widget.categoryList[widget.index]['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? "update" : "add"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: categoryNameController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
          ),
          MaterialButton(
            color: Colors.purple,
            onPressed: () {
              addEditCategory();
            },
            child: Text(
              editMode ? "update" : "Save",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
