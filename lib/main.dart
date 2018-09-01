import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lobste.rs App',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Lobste.rs App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<LobsterData> data() async {
    var response = await http.get("https://lobste.rs/hottest.json");
    if (response.statusCode == 200) {
      // Everything is Good.
      return LobsterData.fromJson(json.decode(response.body));
    } else {
      // TODO: Fix this.
      throw Exception('Oops');
    }

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.items.length,
              itemBuilder: (context, index) {
              return new Material(
                child: InkWell(
                  child: new ListTile(
                    title: Text(snapshot.data.items[index].title),
                    subtitle: Text(snapshot.data.items[index].created_at.toString()),
                    leading: new CircleAvatar(
                      // TODO: Make this colorblind friendly.
                      child: Text(snapshot.data.items[index].score.toString()),
                    ),
                  ),
                  onTap: () {
                    launch(snapshot.data.items[index].short_id_url);
                  },
                ),
              );
            },
          );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class LobsterData {
  final List<LobsterItem> items;

  LobsterData({this.items});
  factory LobsterData.fromJson(List<dynamic> parsedJson){
    List<LobsterItem> items = new List<LobsterItem>();
    items = parsedJson.map((i)=>LobsterItem.fromJson(i)).toList();
    return LobsterData(items: items);
  }

}

class LobsterItem {
  final String short_id_url;
  final DateTime created_at;
  final String title;
  final int score;

  LobsterItem({this.score, this.short_id_url, this.title, this.created_at});
  factory LobsterItem.fromJson(Map<String, dynamic> parsedJson) {
    return new LobsterItem(
      created_at: DateTime.parse(parsedJson['created_at']),
      short_id_url: parsedJson['short_id_url'],
      title: parsedJson['title'],
      score: parsedJson['score']
    );
  }
}
