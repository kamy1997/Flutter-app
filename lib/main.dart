import 'dart:convert';
import 'package:flutter_application_1/Détaille.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String api = "https://api-joueurs.herokuapp.com/api/player";

  bool isLoaded = false;
  late List data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await http.get(Uri.parse(api));
    print(response.body);
    setState(() {
      data = jsonDecode(response.body);
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "players",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green,
        brightness: Brightness.light,
      ),
      body: isLoaded != false
          ? Container(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: data.map((item) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => DetailScreen(
                                  item: item,
                                )),
                      );
                    },
                    child: Hero(
                      tag: item["img"],
                      
                      child: Container(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CachedNetworkImage(
                            imageUrl: item["img"],
                            placeholder: (ctx, str) => Text("Loading..."),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
