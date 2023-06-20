import 'package:rebuilder_example/core/models/comment.dart';
import 'package:rebuilder_example/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:rebuilder/rebuilder.dart';

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
        body: RebuilderWidget<List<Comment>, Comment>(
          url: Services.commentsAPI,
          method: HttpMethod.GET,
          parser: Comment.fromJson,
          builder: (context, state) {
            return state.maybeWhen(
              () => Container(),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              dataReceived: (data) {
                return ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (_, i) {
                    return SizedBox(
                      height: 40,
                      child: Card(
                        child: Column(
                          children: [
                            Text(data?[i].name ?? ""),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              errorReceived: (error) {
                return Center(
                  child: Text(
                    error.message,
                  ),
                );
              },
              orElse: () => Container(),
            );
          },
        ),
      ),
    );
  }
}
