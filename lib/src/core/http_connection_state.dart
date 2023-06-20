import 'package:rebuilder/src/core/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_connection_state.freezed.dart';

@freezed
class HttpConnectionState<T> with _$HttpConnectionState {
  const factory HttpConnectionState() = _HttpConnectionState;
  const factory HttpConnectionState.loading() = _HttpConnectionStateLoading;
  const factory HttpConnectionState.dataReceived(T data) =
      _HttpConnectionStateDataReceived;
  const factory HttpConnectionState.errorReceived(HttpFailure failure) =
      _HttpConnectionStateErrorReceived;
}
