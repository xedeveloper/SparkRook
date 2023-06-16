import 'dart:convert';

class MockComments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  MockComments({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  String toRawJson() => json.encode(toJson());

  static MockComments fromJson(Map<String, dynamic> json) => MockComments(
        postId: json["postId"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };
}
