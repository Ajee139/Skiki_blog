import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:skiki_blog/page/postDetails.dart';

class TopPostCard extends StatefulWidget {
  const TopPostCard({super.key});

  @override
  State<TopPostCard> createState() => _TopPostCardState();
}

class _TopPostCardState extends State<TopPostCard> {
  List postData = [];

  Future<void> showALLPost() async {
    var url =
        Uri.parse("http://localhost/sKiki_blog_flutter/uploads/postAll.php");

    try {
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        setState(() {
          postData = jsonData;
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
    showALLPost();
  }

  @override
  Widget build(BuildContext context) {
    return postData.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SizedBox(
                // color: Colors.amber,
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: postData.length,
                  itemBuilder: (context, index) {
                    var post = postData[index];
                    return NewPostItem(
                      image:
                          'http://localhost/sKiki_blog_flutter/uploads/${post['image']}' ??
                              '',
                      author: post['author'] ?? '',
                      post_date: post['post_date'] ?? '',
                      comments: post['comments'] ?? 0,
                      total_like: post['total_like'] ?? 0,
                      title: post['title'] ?? 'No Title',
                      body: post['body'] ?? '',
                      category_name: post['category_name'] ?? '',
                      create_date: post['create_date'] ?? '',
                    );
                  },
                ),
              ),
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
