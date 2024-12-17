import 'dart:typed_data';

import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';

class addEditPost extends StatefulWidget {
  final List<dynamic>? postList;
  final int? index;
  final String author;

  addEditPost({this.postList, this.index, required this.author});

  @override
  State<addEditPost> createState() => _addEditPostState();
}

class _addEditPostState extends State<addEditPost> {
  XFile? image; // Selected image file
  Uint8List? imageBytes; // Image data as bytes
  final picker = ImagePicker();
  String? selectedCategory;

  List categoryItem = [];

  Future<void> getAllCategory() async {
    var url = Uri.parse(
        "http://localhost/sKiki_blog_flutter/uploads/categoryAll.php");

    try {
      var response = await http.post(url, body: {});

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);

        setState(() {
          categoryItem = jsonData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  bool editMode = false;

  Future<void> choiceImage() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
        imageBytes = await pickedImage.readAsBytes(); // Get image bytes
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> addEditPost() async {
    final url = editMode
        ? Uri.parse(
            "http://localhost/sKiki_blog_flutter/uploads/updatePost.php")
        : Uri.parse("http://localhost/sKiki_blog_flutter/uploads/addPost.php");

    try {
      var request = http.MultipartRequest("POST", url);
      if (editMode) {
        request.fields['id'] = widget.postList![widget.index!]['id'];
      }
      request.fields['title'] = title.text;
      request.fields['body'] = body.text;
      request.fields['author'] = widget.author;
      request.fields['category_name'] = selectedCategory!;

      // Add image if selected
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes('image', imageBytes!,
              filename: image?.name ?? 'image.jpg'),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: editMode
                ? "Post updated successfully"
                : "Post added successfully",
            fontSize: 20);
        Navigator.pop(context);
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
    getAllCategory();
    if (widget.index != null) {
      editMode = true;
      title.text = widget.postList![widget.index!]['title'];
      body.text = widget.postList![widget.index!]['body'];
      selectedCategory = widget.postList![widget.index!]['category_name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode ? "Update Post" : "Add Post",
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Post title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 4,
              controller: body,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
          ),
          IconButton(
              onPressed: choiceImage, icon: const Icon(Icons.image, size: 50)),
          if (editMode &&
              widget.postList![widget.index!]['image'] != null &&
              image == null)
            Image.network(
              "http://localhost/sKiki_blog_flutter/uploads/${widget.postList![widget.index!]['image']}",
              width: 100,
              height: 100,
            )
          else if (imageBytes != null)
            Image.memory(
              imageBytes!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
          else
            const Text('No image selected.'),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: DropdownButton(
              isExpanded: true,
              value: selectedCategory,
              items: categoryItem.map((category) {
                return DropdownMenuItem(
                    value: category['name'], child: Text(category['name']));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue as String?;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: addEditPost,
              child: const Text("Save Post"),
            ),
          )
        ],
      ),
    );
  }
}
