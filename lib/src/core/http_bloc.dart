import 'dart:async';

import 'package:api_widget/src/dio_client.dart';
import 'package:api_widget/src/src_export.dart';
import 'package:dio/dio.dart';

class HttpBloc<T> {
  final StreamController<T> _requestStreamController = StreamController<T>();

  final Dio _dio = NetworkHelper.getDioClient();

  get httpStream {
    return _requestStreamController.stream;
  }

  void initiateHttpRequest<P>({
    required HttpMethod method,
    required String url,
    dynamic Function(Map<String, dynamic>)? parser,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? extra,
  }) async {
    final _result = await _dio.fetch<dynamic>(
      _setStreamType<T>(
        Options(
          method: method.name,
          headers: headers,
          extra: extra,
          responseType: ResponseType.json,
        ).compose(
          _dio.options,
          url,
          queryParameters: queryParameters,
          data: data,
        ),
      ),
    );
    var value = _result.data;
    if (parser != null) {
      if (value is List) {
        var mappedValue = value.map((e) => parser(e) as P).toList();
        _requestStreamController.sink.add(mappedValue as T);
      } else {
        var parsedValue = parser(value);
        _requestStreamController.sink.add(parsedValue);
      }
    } else {
      _requestStreamController.sink.add(value);
    }
  }

  RequestOptions _setStreamType<V>(RequestOptions requestOptions) {
    if (V != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (V == String) {
        requestOptions.responseType == ResponseType.plain;
      } else {
        requestOptions.responseType == ResponseType.json;
      }
    }
    return requestOptions;
  }
}
