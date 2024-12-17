import "package:flutter/material.dart";

class PostDetails extends StatelessWidget {
  final title;
  final author;
  final post_date;
  final image;
  final body;
  const PostDetails(
      {super.key,
      required this.title,
      required this.author,
      required this.post_date,
      required this.image,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PostDetails"),
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontFamily: "FontSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.network(
                    scale: 0.5,
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    body ?? "",
                    style: const TextStyle(
                        fontFamily: "FontSans",
                        fontWeight: FontWeight.normal,
                        fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "by " + author,
                    style: const TextStyle(
                        fontFamily: "FontSans",
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Posted on: " + post_date,
                    style: const TextStyle(
                        fontFamily: "FontSans",
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Comments Section",
                  style: TextStyle(
                      fontFamily: "FontSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid)),
                            hintText: "Drop your comments here",
                            hintStyle: TextStyle(
                              color: Colors.grey[200],
                            )),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            color: Colors.blue,
                            child: const Text("Comment",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {}))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
