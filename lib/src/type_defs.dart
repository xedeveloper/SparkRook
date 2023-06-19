import 'package:api_widget/src/core/http_connection_state.dart';
import 'package:flutter/widgets.dart';

typedef AsyncDataBuilder<T> = Widget Function(
  BuildContext context,
  HttpConnectionState<T>,
);
