import 'package:api_widget_example/core/models/comment.dart';
import 'package:api_widget_example/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:api_widget/api_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: APIContainerWidget<List<Comment>, Comment>(
          url: Services.commentsAPI,
          method: HttpMethod.GET,
          parser: Comment.fromJson,
          builder: (context, data) {
            return ListView.builder(
              itemCount: data?.length ?? 0,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Text(data?[i].name ?? ""),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
