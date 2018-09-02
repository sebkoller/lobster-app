import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:lobsters_app/api.dart';
import 'package:http/http.dart' as http;

class CommentView extends StatefulWidget {
  final LobsterItem item;

  CommentView({@required this.item});

  @override
  CommentViewState createState() {
    return new CommentViewState();
  }
}

class CommentViewState extends State<CommentView> {
  Future<LobsterComments> data() async {
    var response =
        await http.get(widget.item.short_id_url + ".json");
    if (response.statusCode == 200) {
      // Everything is Good.
      return LobsterComments.fromJson(json.decode(response.body));
    } else {
      // TODO: Fix this.
      throw Exception('Oops');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.items.length,
              itemBuilder: (context, index) {

                return new Container(
                    child: new Card(
                        child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          new Padding(
                              child: Row(
                                children: <Widget>[
                                  new Icon(Icons.comment),
                                  new Text(
                                      " ${snapshot.data.items[index].score.toString()} - ${snapshot.data.items[index].commenting_user.username}",
                                      textAlign: TextAlign.right,
                                      textScaleFactor: 1.0,
                                      style: new TextStyle(
                                          color: Colors.black.withOpacity(0.6))),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 16.0)),
                          new Padding(
                            // TODO: This library is... weird. It prints things to stdout for no reason and it has a low score on dartpub.
                            // Find a replacement for this soon.
                              child: new HtmlView(data: snapshot.data.items[index].comment),
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 16.0,
                                  bottom: 16.0))
                        ])),
                    padding: new EdgeInsets.only(
                        left: 4.0 + snapshot.data.items[index].indent_level * 10,
                        right: 16.0,
                        top: snapshot.data.items[index].indent_level == 0 ? 16.0 : 2.0,
                        bottom: 0.0));
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
