import 'package:api_widget_example/models/comment.dart';
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
        appBar: AppBar(
          title: const Text('API Example'),
        ),
        body: Center(
          child: APIContainerWidget<List<Comment>, Comment>(
            url: "https://jsonplaceholder.typicode.com/comments",
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
      ),
    );
  }
}
