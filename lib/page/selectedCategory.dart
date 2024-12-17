import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:skiki_blog/page/postDetails.dart';

class Selectedcategory extends StatefulWidget {
  final String categoryName;

  const Selectedcategory({super.key, required this.categoryName});

  @override
  State<Selectedcategory> createState() => _SelectedcategoryState();
}

class _SelectedcategoryState extends State<Selectedcategory> {
  List categoryByPost = [];

  // Fetch posts for the selected category from the server
  Future getAllCategoryPost() async {
    var url = Uri.parse(
        "http://localhost/sKiki_blog_flutter/uploads/categoryByPost.php"); // Correct URL

    try {
      var response = await http
          .post(url, body: {"name": widget.categoryName}); // Correct body

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);

        setState(() {
          categoryByPost = jsonData;
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
    getAllCategoryPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: categoryByPost.isEmpty
          ? const Center(child: Text('No posts available for this category.'))
          : ListView.builder(
              itemCount: categoryByPost.length, // Dynamically set itemCount
              itemBuilder: (context, index) {
                // Handle null title
                return NewPostItem(
                  image:
                      'http://localhost/sKiki_blog_flutter/uploads/${categoryByPost[index]['image']}' ??
                          '',
                  author: categoryByPost[index]['author'] ?? '',
                  post_date: categoryByPost[index]['post_date'] ?? '',
                  comments: categoryByPost[index]['comments'] ?? 0,
                  total_like: categoryByPost[index]['total_like'] ?? 0,
                  title: categoryByPost[index]['title'] ?? 'No Title',
                  body: categoryByPost[index]['body'] ?? '',
                  category_name: categoryByPost[index]['category_name'] ?? '',
                  create_date: categoryByPost[index]['create_date'] ?? '',
                );
              },
            ),
    );
  }
}

class NewPostItem extends StatelessWidget {
  final image;
  final author;
  final post_date;
  final comments;
  final total_like;
  final title;
  final body;
  final category_name;
  final create_date;

  const NewPostItem({
    super.key,
    required this.image,
    required this.author,
    required this.post_date,
    required this.comments,
    required this.total_like,
    required this.title,
    required this.body,
    required this.category_name,
    required this.create_date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
                gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.amber,
                      Colors.pink,
                    ])),
          ),
          Positioned(
              top: 30,
              left: 30,
              child: CircleAvatar(
                radius: 20,
                // child: Icon(Icons.person),
                backgroundImage: NetworkImage(image),
              )),
          Positioned(
              top: 30,
              left: 100,
              child: Text(
                author,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "OpenSans"),
              )),
          Positioned(
              top: 30,
              left: 150,
              child: Text(
                post_date,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                    fontFamily: "OpenSans"),
              )),
          const Positioned(
              top: 50,
              left: 110,
              child: Icon(
                Icons.comment,
                color: Colors.white,
              )),
          Positioned(
              top: 50,
              left: 140,
              child: Text(
                comments,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                    fontFamily: "OpenSans"),
              )),
          const Positioned(
              top: 50,
              left: 180,
              child: Icon(
                Icons.thumb_up_sharp,
                size: 20,
                color: Colors.white,
              )),
          Positioned(
              top: 50,
              left: 210,
              child: Text(
                total_like,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                    fontFamily: "OpenSans"),
              )),
          Positioned(
              top: 100,
              left: 30,
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                    fontFamily: "OpenSans"),
              )),
          Positioned(
              top: 150,
              left: 30,
              child: InkWell(
                  child: Text(
                    "Read more",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[200],
                        fontFamily: "OpenSans"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetails(
                                  title: title,
                                  author: author,
                                  post_date: post_date,
                                  body: body,
                                  image: image,
                                )));
                  })),
          Positioned(
              top: 150,
              left: 120,
              child: Icon(
                Icons.arrow_forward_outlined,
                color: Colors.grey[200],
                size: 20,
              )),
        ],
      ),
    );
  }
}
