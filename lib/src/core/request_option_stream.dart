import 'package:dio/dio.dart';

/// Handles streamType conversion based on expected responses
class RequestOptionsStream {
  /// returns [RequestTopns] with response Types handled according
  /// to the provided response type.
  ///
  /// returns response type as Plain if value is String
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
