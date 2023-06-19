# API Widget Builder

## About

A flutter widget to replace all your API call logic. Want to call an API on the go? Just embed this widget in your project.

### Installing

---

To use this package in your Flutter project add this to your `pubspec.yaml`

```yaml
dependencies:
  api_widget:
    git:
      url: https://github.com/xedeveloper/api_widget.git
```

### Usage

```dart
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: APIContainerWidget<List<Comment>, Comment>(
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
```
