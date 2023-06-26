import 'dart:async';

import 'package:sparkrook/src/core/errors/failure.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/core/request_option_stream.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';

/// Creates a [RookHandler] with type [T] which handles the state of API
/// [RookHandler] will manage the stream, dio client & the parsing logic
/// of the API
class RookHandler<T> {
  /// Creates a [StreamController] which takes RookState as type.
  ///
  /// StreamController will handle the stream for the [SparkRookWidget]
  final StreamController<RookState<T>> _requestStreamController =
      StreamController<RookState<T>>();

  /// Creates a Stream with [RookState] as data stream.
  /// [RookState] will notify the process of stream
  Stream<RookState<T>> get rook {
    return _requestStreamController.stream;
  }

  /// Creates a [StreamSink] with [RookState] as data
  /// outputs of [RookState] process will get added using this
  StreamSink<RookState<T>> get _httpSink {
    return _requestStreamController.sink;
  }

  /// Initiates the HTTP request from [SparkRookWidget].
  ///
  /// * [method] : HTTP method like GET, POST, DELETE, etc required.
  /// * [url]: URL is required to initiate the API call
  /// * [dio]: Dio client will handle the fetching logic of the call
  ///
  /// [parser] will handle the parsing logic. Parser is required for
  /// complex data types expected from response
  ///
  /// [headers] (optional) headers data if required to make an API call
  ///
  /// [queryParameters] (optional) additional query parameters if required
  /// for the API call
  ///
  /// [data] (optional) additional data if required for API call
  ///
  /// [extra] (optional) extra data options if required for API call.
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

  /// Get [RequestOptions] to set the streamType for dio
  RequestOptions _setStreamType<V>(RequestOptions requestOptions) {
    return RequestOptionsStream.setStreamType(requestOptions);
  }

  /// Disposing [StreamController] afeter usage
  void dispose() {
    _requestStreamController.close();
  }
}
