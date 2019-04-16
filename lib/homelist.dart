import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:lobsters_app/api.dart';
import 'package:lobsters_app/comments.dart';
import 'package:lobsters_app/utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart';

class HomeList extends StatefulWidget {
  final String endpoint;

  HomeList({@required this.endpoint});

  @override
  HomeListState createState() {
    return new HomeListState();
  }
}

class HomeListState extends State<HomeList> {
  Future<LobsterData> data() async {
    var response = await http.get(widget.endpoint);
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
    return FutureBuilder(
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
                      subtitle: buildSubtitle(snapshot.data.items[index]),
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
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Text buildSubtitle(LobsterItem item) {
    final timeSpan = utils.getAbbreviatedTimeSpan(item.created_at);
    return Text('$timeSpan - ${item.submitter_user.username}');
  }
}
