import 'package:flutter/material.dart';
import 'package:lobsters_app/homelist.dart';
import 'package:lobsters_app/settings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(new LobstersApp());

// Parent class for cleaner app-wide theme changes.

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

// The actual homepage.

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: HomeList(endpoint: "https://lobste.rs/hottest.json",),
    );
  }
}
