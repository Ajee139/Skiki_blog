import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:skiki_blog/page/selectedCategory.dart';

class Categorylistitem extends StatefulWidget {
  const Categorylistitem({super.key});

  @override
  State<Categorylistitem> createState() => _CategorylistitemState();
}

class _CategorylistitemState extends State<Categorylistitem> {
  List categories = [];

  // Fetch categories from the server
  Future getAllCategory() async {
    var url = Uri.parse(
        "http://localhost/sKiki_blog_flutter/uploads/categoryAll.php");

    try {
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      print(response.body); // Debugging

      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        setState(() {
          categories = jsonData;
        });
        print(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // Call getAllCategory when widget is initialized
  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            categoryName: categories[index]["name"],
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;

  const CategoryItem({super.key, required this.categoryName});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(widget.categoryName,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Selectedcategory(categoryName: widget.categoryName)));
          // Define the action when a category is tapped
          debugPrint("Tapped on category: ${widget.categoryName}");
        },
      ),
    );
  }
}
