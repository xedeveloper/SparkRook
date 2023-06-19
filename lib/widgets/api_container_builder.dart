import 'package:api_widget/src/core/http_bloc.dart';
import 'package:api_widget/src/core/http_connection_state.dart';
import 'package:api_widget/src/src_export.dart';
import 'package:flutter/widgets.dart';

class APIContainerWidget<T, P> extends StatelessWidget {
  final AsyncDataBuilder<T> builder;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? extra;
  final HttpMethod method;
  final dynamic Function(Map<String, dynamic>)? parser;
  final String url;

  final HttpBloc<T> _httpBloc = HttpBloc<T>();
  APIContainerWidget({
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
