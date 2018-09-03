import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lobsters_app/comments.dart';
import 'package:lobsters_app/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lobsters_app/api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(new LobstersApp());

class LobstersApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  LobstersAppState createState() {
    return new LobstersAppState();
  }
}

class LobstersAppState extends State<LobstersApp> {

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primaryColor: Colors.red[900],
          accentColor: Colors.red[500],
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) { return new MaterialApp(
          title: 'Lobste.rs App',
          theme: theme,
          home: new MyHomePage(title: 'Lobste.rs App'),
        ); 
      }
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("not_signed_in"),
              accountName: Text("Not Signed In"),
              currentAccountPicture: CircleAvatar(),
              onDetailsPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Coming Soon"),
                      content: Text(
                          "Lobste.rs hasn't implemented OAuth for sign in yet, but work is in progress."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: new Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),));
              },
            ),
          ],
        ),
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
                    child: Slidable(
                      delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child: new ListTile(
                        title: Text(snapshot.data.items[index].title),
                        subtitle: Text(
                            snapshot.data.items[index].created_at.toString()),
                        leading: new CircleAvatar(
                          child:
                              Text(snapshot.data.items[index].score.toString()),
                        ),
                      ),
                      actions: <Widget>[
                        new IconSlideAction(
                          caption: "Read Article",
                          color: Colors.blue,
                          icon: Icons.link,
                          onTap: () => launch(snapshot.data.items[index].url),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentView(
                                  item: snapshot.data.items[index],
                                ),
                          ));
                      //launch(snapshot.data.items[index].short_id_url);
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
