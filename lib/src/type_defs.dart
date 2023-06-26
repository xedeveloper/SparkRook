import 'package:sparkrook/src/core/rook_state.dart';
import 'package:flutter/widgets.dart';

///  [SparkRookWidget], which delegates to an [AsyncSparkBuilder] to build
/// itself based on the State of the Rook which handles the API
typedef AsyncSparkBuilder<T> = Widget Function(
  BuildContext context,
  RookState<T>,
);
