import 'package:sparkrook/src/core/rook_state.dart';
import 'package:flutter/widgets.dart';

typedef AsyncSparkBuilder<T> = Widget Function(
  BuildContext context,
  RookState<T>,
);
