import 'package:dio/dio.dart';

class RequestOptionsStream {
  static RequestOptions setStreamType<V>(RequestOptions requestOptions) {
    if (V != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (V == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
