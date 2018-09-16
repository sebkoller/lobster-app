import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<Settings> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool("usr_darkMode") ?? false;
    return new Settings(
      darkMode: darkMode,
    );
  }

  void setSettings(String setting, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(setting, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: FutureBuilder(
        future: getSettings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                _BooleanItem("Dark Theme",
                    Theme.of(context).brightness == Brightness.dark,
                    (bool value) {
                  DynamicTheme.of(context).setBrightness(
                      value ? Brightness.dark : Brightness.light);
                }),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Settings {
  bool darkMode;
  Settings({this.darkMode});
}

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(this.title, this.value, this.onChanged, {this.switchKey});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  // [switchKey] is used for accessing the switch from driver tests.
  final Key switchKey;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
          new Expanded(child: new Text(title)),
          new Switch(
            key: switchKey,
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF39CEFD),
            activeTrackColor: isDark ? Colors.white30 : Colors.black26,
          ),
        ],
      ),
    );
  }
}

class _OptionsItem extends StatelessWidget {
  const _OptionsItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return new MergeSemantics(
      child: new Container(
        constraints: new BoxConstraints(minHeight: 48.0 * textScaleFactor),
        padding: EdgeInsets.only(right: 4.0, left: 16.0, bottom: 4.0, top: 8.0),
        alignment: AlignmentDirectional.centerStart,
        child: new DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child: new IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: child,
          ),
        ),
      ),
    );
  }
}
