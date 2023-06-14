import 'package:flutter/widgets.dart';

typedef AsyncDataBuilder<T> = Widget Function(BuildContext context, T? data);