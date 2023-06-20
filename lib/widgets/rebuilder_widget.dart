import 'package:rebuilder/src/core/http_bloc.dart';
import 'package:rebuilder/src/core/http_connection_state.dart';
import 'package:rebuilder/src/network_helper.dart';
import 'package:rebuilder/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class RebuilderWidget<T, P> extends StatelessWidget {
  final AsyncDataBuilder<T> builder;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? extra;
  final HttpMethod method;
  final dynamic Function(Map<String, dynamic>)? parser;
  final String url;
  final Dio _dio = NetworkHelper.getDioClient();
  final HttpBloc<T> _httpBloc = HttpBloc<T>();

  RebuilderWidget({
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
    return StreamBuilder<HttpConnectionState<T>>(
      initialData: HttpConnectionState.loading(),
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