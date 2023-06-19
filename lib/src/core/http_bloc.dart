import 'dart:async';

import 'package:api_widget/src/core/errors/failure.dart';
import 'package:api_widget/src/core/http_connection_state.dart';
import 'package:api_widget/src/core/request_option_stream.dart';
import 'package:api_widget/src/network_helper.dart';
import 'package:api_widget/src/src_export.dart';
import 'package:dio/dio.dart';

class HttpBloc<T> {
  final StreamController<HttpConnectionState<T>> _requestStreamController =
      StreamController<HttpConnectionState<T>>();

  Stream<HttpConnectionState<T>> get httpStream {
    return _requestStreamController.stream;
  }

  StreamSink<HttpConnectionState<T>> get _httpSink {
    return _requestStreamController.sink;
  }

  void initiateHttpRequest<P>({
    required HttpMethod method,
    required String url,
    required Dio dio,
    dynamic Function(Map<String, dynamic>)? parser,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? extra,
  }) async {
    _httpSink.add(HttpConnectionState.loading());
    Response<dynamic>? _result;
    try {
      _result = await dio.fetch<dynamic>(
        _setStreamType<T>(
          Options(
            method: method.name,
            headers: headers,
            extra: extra,
            responseType: ResponseType.json,
          ).compose(
            dio.options,
            url,
            queryParameters: queryParameters,
            data: data,
          ),
        ),
      );
    } catch (error) {
      _httpSink.add(
        HttpConnectionState.errorReceived(
          HttpFailure(
            Exception((error as DioException).message),
          ),
        ),
      );
    }
    if (_result != null) {
      var value = _result.data;
      if (parser != null) {
        if (value is List) {
          var mappedValue = value.map((e) => parser(e) as P).toList();
          _httpSink.add(
            HttpConnectionState.dataReceived(mappedValue as T),
          );
        } else {
          var parsedValue = parser(value);
          _httpSink.add(
            HttpConnectionState.dataReceived(parsedValue),
          );
        }
      } else {
        if (value.runtimeType != T) {
          _httpSink.add(HttpConnectionState.errorReceived(HttpFailure(
            Exception(
              "Error: The current value does not match with expected value. Please provide a parser",
            ),
          )));
        } else {
          _httpSink.add(HttpConnectionState.dataReceived(value));
        }
      }
    }
  }

  RequestOptions _setStreamType<V>(RequestOptions requestOptions) {
    return RequestOptionsStream.setStreamType(requestOptions);
  }
}
