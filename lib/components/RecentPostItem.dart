import "package:flutter/material.dart";
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:skiki_blog/page/postDetails.dart';

class RecentPostItem extends StatefulWidget {
  const RecentPostItem({super.key});

  @override
  State<RecentPostItem> createState() => _RecentPostItemState();
}

class _RecentPostItemState extends State<RecentPostItem> {
  List recentPost = [];

  Future<void> recentPostData() async {
    var url =
        Uri.parse("http://localhost/sKiki_blog_flutter/uploads/postAll.php");

    try {
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        setState(() {
          recentPost = jsonData;
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
    recentPostData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: recentPost.length,
        itemBuilder: (context, index) {
          return RecentItem(
            title: recentPost[index]['title'],
            author: recentPost[index]['author'],
            date: recentPost[index]['create_date'],
            body: recentPost[index]['body'],
            image:
                "http://localhost/sKiki_blog_flutter/uploads/${recentPost[index]['image']}",
          );
        },
      ),
    );
  }
}

class RecentItem extends StatefulWidget {
  final image;
  final author;
  final date;
  final title;
  final body;
  const RecentItem(
      {super.key,
      required this.image,
      required this.author,
      required this.date,
      required this.title,
      this.body});

  @override
  State<RecentItem> createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetails(
                                  image: widget.image,
                                  author: widget.author,
                                  title: widget.title,
                                  post_date: widget.date,
                                  body: widget.body,
                                )));
                    debugPrint(widget.title);
                  },
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "FontSans",
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'By: ' + widget.author,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text(
                        'Posted on: ' + widget.date,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 62, 55, 55)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.network(
                fit: BoxFit.fitHeight,
                widget.image,
                height: 70,
                width: 70,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
