import 'dart:async';

import 'package:sparkrook/src/core/errors/failure.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/core/request_option_stream.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';

class SparkBloc<T> {
  final StreamController<RookState<T>> _requestStreamController =
      StreamController<RookState<T>>();

  Stream<RookState<T>> get httpStream {
    return _requestStreamController.stream;
  }

  StreamSink<RookState<T>> get _httpSink {
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
    _httpSink.add(RookState.loading());
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
        RookState.errorReceived(
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
            RookState.dataReceived(mappedValue as T),
          );
        } else {
          var parsedValue = parser(value);
          _httpSink.add(
            RookState.dataReceived(parsedValue),
          );
        }
      } else {
        if (value.runtimeType != T) {
          _httpSink.add(RookState.errorReceived(HttpFailure(
            Exception(
              "Error: The current value does not match with expected value. Please provide a parser",
            ),
          )));
        } else {
          _httpSink.add(RookState.dataReceived(value));
        }
      }
    }
  }

  RequestOptions _setStreamType<V>(RequestOptions requestOptions) {
    return RequestOptionsStream.setStreamType(requestOptions);
  }
}
