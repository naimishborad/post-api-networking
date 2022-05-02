import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      
      home: Home()
    );
  }
}


Future<Album> createAlbum(String title) async{
  final response =await http.post(Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  headers: <String,String> {
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String,String>{
    'title':title
  })
  );
  if(response.statusCode == 201){
    return Album.fromJson(jsonDecode(response.body));
  }
  else{
    throw Exception('Failed to create album');
  }
}
class Album {
  final int? id;
  final String? title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String,dynamic> json){
    return Album(
    id: json['id'],
    title: json['title']
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              builColumn(),
              buildFutureBuilder()
            ],
          )
        ),
      ),
    );
  }
  Column builColumn(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Enter Title"),
        ),
      ),
      ElevatedButton(onPressed: (){
        setState(() {
          _futureAlbum = createAlbum(_controller.text);
        });
      }, child: Text("Create Data"))
    ],
  );
}

FutureBuilder<Album> buildFutureBuilder(){
  return FutureBuilder<Album>(
    future: _futureAlbum,
    builder: (context,snapshot){
      if(snapshot.hasData){
        return Text(snapshot.data!.title.toString());
      }
      else if(snapshot.hasError){
        return Text("${snapshot.error}");
      }
      else{
        return Text("Title");
      }
    },
  );
}
}