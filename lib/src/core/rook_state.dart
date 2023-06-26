import 'package:sparkrook/src/core/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rook_state.freezed.dart';

/// Creates a freezed [RookState] which is used determine
/// the current state of API call.
@freezed
class RookState<T> with _$RookState {
  /// Intial class State. returns [_RookState]
  const factory RookState() = _RookState;

  /// Indicates loading state of the API call. After creation of
  /// [SparkRookWidget] loading state will get emited.
  const factory RookState.loading() = _RookStateLoading;

  /// Indicates success of API response. After data is received the
  /// [RookHandler] will emit [dataReceived] with data for the [SparkRookWidget]
  const factory RookState.dataReceived(T data) = _RookStateDataReceived;

  /// Indicates failure of API response. If API is failed to handle the data
  /// then the [RookHandler] will emit error state to let [SparRookWidget]
  /// handle the error of API.
  const factory RookState.errorReceived(HttpFailure failure) =
      _RookStateErrorReceived;
}
