/// Abstract error handling class which takes [Exception]
abstract class Failure {
  final Exception exception;
  Failure(this.exception);
}

/// Creates a [HttpFailure] object with [Exception]
/// Used to get handle the error on [RookHandler]
class HttpFailure extends Failure {
  HttpFailure(Exception exception) : super(exception);

  /// Returns the [String] message of Error.
  String get message {
    return exception.toString();
  }
}
