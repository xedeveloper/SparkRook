import 'package:sparkrook/src/core/spark_bloc.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/network_helper.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class SparkRookWidget<T, P> extends StatelessWidget {
  final AsyncSparkBuilder<T> builder;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? extra;
  final HttpMethod method;
  final dynamic Function(Map<String, dynamic>)? parser;
  final String url;
  final Dio _dio = NetworkHelper.getDioClient();
  final SparkBloc<T> _httpBloc = SparkBloc<T>();

  SparkRookWidget({
    super.key,
    required this.builder,
    required this.url,
    required this.method,
    this.parser,
    this.queryParameters,
    this.data,
    this.extra,
    this.headers,
  }) {
    _httpBloc.initiateHttpRequest<P>(
      method: method,
      url: url,
      dio: _dio,
      queryParameters: queryParameters,
      data: data,
      extra: extra,
      headers: headers,
      parser: parser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RookState<T>>(
      initialData: RookState.loading(),
      stream: _httpBloc.httpStream,
      builder: (context, snapshot) {
        return builder(
          context,
          snapshot.data!,
        );
      },
    );
  }
}
