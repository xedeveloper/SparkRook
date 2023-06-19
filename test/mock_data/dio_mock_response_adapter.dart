import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class DioMockResponseAdapter implements HttpClientAdapter {
  final MockAdapterInterceptor interceptor;
  DioMockResponseAdapter(this.interceptor);
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    if (options.method == interceptor.type.name.toUpperCase() &&
        options.baseUrl == interceptor.uri) {
      return Future.value(
        ResponseBody.fromString(
          jsonEncode(interceptor.serializableResponse),
          interceptor.responseCode,
          headers: {
            "content-type": ["application/json"]
          },
        ),
      );
    }
    return Future.value(ResponseBody.fromString(
      jsonEncode(
        {"error": "Request doesn't match with mock inteerceptor"},
      ),
      -1,
    ));
  }
}

enum RequestType {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

class MockAdapterInterceptor {
  final RequestType type;
  final String uri;
  final String path;
  final Map<String, dynamic> query;
  final Object? serializableResponse;
  final int responseCode;

  MockAdapterInterceptor(
    this.type,
    this.uri,
    this.path,
    this.query,
    this.serializableResponse,
    this.responseCode,
  );
}
