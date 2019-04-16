// This is the class for the JSON returned from the homepage.
class LobsterData {
  final List<LobsterItem> items;

  LobsterData({this.items});
  factory LobsterData.fromJson(List<dynamic> parsedJson) {
    List<LobsterItem> items = new List<LobsterItem>();
    items = parsedJson.map((i) => LobsterItem.fromJson(i)).toList();
    return LobsterData(items: items);
  }
}

// This is the class for each item, used in various other places.
// TODO: Add more properties, this isn't all of them.
class LobsterItem {
  final String short_id;
  final String short_id_url;
  final String url;
  final DateTime created_at;
  final String title;
  final int score;
  final User submitter_user;

  LobsterItem(
      {this.score,
      this.short_id,
      this.title,
      this.created_at,
      this.short_id_url,
      this.url,
      this.submitter_user});
  factory LobsterItem.fromJson(Map<String, dynamic> parsedJson) {
    return new LobsterItem(
        created_at: DateTime.parse(parsedJson['created_at']),
        short_id: parsedJson['short_id'],
        short_id_url: parsedJson['short_id_url'],
        url: parsedJson['url'],
        title: parsedJson['title'],
        score: parsedJson['score'],
        submitter_user: User.fromJson(parsedJson['submitter_user']));
  }
}

// This is the parent object that contains the comments on a comments page.
class LobsterComments {
  final List<Comment> items;

  LobsterComments({this.items});
  factory LobsterComments.fromJson(Map<String, dynamic> parsedJson) {
    List<Comment> items = new List<Comment>();
    var comments = parsedJson["comments"] as List;
    items = comments.map((i) => Comment.fromJson(i)).toList();
    return LobsterComments(items: items);
  }
}

// Each individual comment looks like this.
// TODO: Add more properties, this isn't all of them.
class Comment {
  final String short_id;
  final DateTime created_at;
  final String comment;
  final User commenting_user;
  final int indent_level;
  final int score;

  Comment(
      {this.score,
      this.short_id,
      this.created_at,
      this.comment,
      this.commenting_user,
      this.indent_level});
  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return new Comment(
      created_at: DateTime.parse(parsedJson['created_at']),
      short_id: parsedJson['short_id'],
      score: parsedJson['score'],
      comment: parsedJson['comment'],
      commenting_user: User.fromJson(parsedJson['commenting_user']),
      indent_level: parsedJson['indent_level'],
    );
  }
}

// Each individual user looks like this.
// TODO: Add more properties, this isn't all of them.
class User {
  final String username;
  final String avatar_url;
  final DateTime created_at;
  final bool is_admin;

  User({this.username, this.avatar_url, this.created_at, this.is_admin});
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      created_at: DateTime.parse(parsedJson['created_at']),
      username: parsedJson['username'],
      avatar_url: parsedJson['avatar_url'],
      is_admin: parsedJson['is_admin'],
    );
  }
}
