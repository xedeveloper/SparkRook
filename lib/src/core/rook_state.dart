import 'package:sparkrook/src/core/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rook_state.freezed.dart';

@freezed
class RookState<T> with _$RookState {
  const factory RookState() = _RookState;
  const factory RookState.loading() = _RookStateLoading;
  const factory RookState.dataReceived(T data) = _RookStateDataReceived;
  const factory RookState.errorReceived(HttpFailure failure) =
      _RookStateErrorReceived;
}
