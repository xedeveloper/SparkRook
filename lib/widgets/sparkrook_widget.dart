import 'package:sparkrook/src/core/rook_handler.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/network_helper.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// Creates a SparkRookWidget with builder which returns the state & the data of url
/// * Type T SparkRookWidget<List<String>,String>
/// First type will be the full expected data type of the response expected.
/// for e.g. If an api returns list of string then type1 will be List<String>
///
/// * Type P SparkRookWidget<List<String>,String>
/// The secondary type will be the sub data expected from the response.
/// for e.g. If an api returns list of string then type2 must be String.
/// The second type is used to parse the returned json data to desired model
///
/// If an API returns defined value such as bool then the parser will be:
/// SparkRookWidget<bool,bool>
class SparkRookWidget<T, P> extends StatefulWidget {
  /// Creates a new instance of [SparkRookWidget] that builds itself based on
  /// the state of the request & response
  /// the interaction is initialized with the [builder] method which handles the state
  /// of the API. followed by [url] which represents the API & [method] type
  /// the request is initialized at the initialzation.
  const SparkRookWidget({
    super.key,
    required this.builder,
    required this.url,
    required this.method,
    this.parser,
    this.queryParameters,
    this.data,
    this.extra,
    this.headers,
    this.dioClient,
  });

  /// [builder] takes AsyncSparkBuilder which returns a widget to handle
  /// the state of the response. [AsyncSparkBuilder] takes a type [T] which
  /// is the response expected from the API call
  final AsyncSparkBuilder<T> builder;

  ///[queryParameters] are required if you need to pass some parameters
  ///to the Dio request. It takes Map<String,dynamic> which is optional value
  final Map<String, dynamic>? queryParameters;

  ///[headers] are required if you need to pass headers
  ///to the Dio request. It takes Map<String,dynamic> which is optional value
  final Map<String, dynamic>? headers;

  ///[data] are required if you need to pass data
  ///to the Dio request. It takes Map<String,dynamic> which is optional value
  final Map<String, dynamic>? data;

  ///[extra] are required if you need to pass extra data
  ///to the Dio request. It takes Map<String,dynamic> which is optional value
  final Map<String, dynamic>? extra;

  /// To make an API call you need to specify [method] which takes GET,POST,
  /// PATCH, etc as options. It is required to make an API call.
  final HttpMethod method;

  /// To parse fetched json response to expected response model [parser] is
  /// required. A parser takes Function(Map<String,dynamic>)? which returns
  /// the expected Model.
  /// Please check example in the project
  /// {@github example: https://github.com/xedeveloper/SparkRook/tree/develop/example}
  final dynamic Function(Map<String, dynamic>)? parser;

  /// To initiate a API call [url] is required. parameter takes String.
  ///
  /// Note: Specify the full url in the paramter
  final String url;

  /// To allow injection of custom dio client to [SparkRookWidget]
  /// If [dioClient] is not provided then library will switch to
  /// default Dio client
  final Dio? dioClient;

  @override
  State<SparkRookWidget<T, P>> createState() => _SparkRookWidgetState<T, P>();
}

class _SparkRookWidgetState<T, P> extends State<SparkRookWidget<T, P>> {
  @override
  void initState() {
    super.initState();
    _rookHandler.initiateHttpRequest<P>(
      method: widget.method,
      url: widget.url,
      dio: widget.dioClient ?? _dio,
      queryParameters: widget.queryParameters,
      extra: widget.extra,
      headers: widget.headers,
      parser: widget.parser,
    );
  }

  /// [_dio] client is created with default configuration.
  final Dio _dio = NetworkHelper.getDioClient();

  /// [_rookHandler] is a BLoC like structure which handles the
  /// API calls & business logic related to request & response
  final RookHandler<T> _rookHandler = RookHandler<T>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RookState<T>>(
      initialData: RookState.loading(),
      stream: _rookHandler.rook,
      builder: (context, snapshot) {
        return widget.builder(
          context,
          snapshot.data!,
        );
      },
    );
  }

  /// Disposing [RookHandler] after usage
  @override
  void dispose() {
    super.dispose();
    _rookHandler.dispose();
  }
}
