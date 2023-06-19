abstract class Failure {
  final Exception exception;
  Failure(this.exception);
}

class HttpFailure extends Failure {
  HttpFailure(Exception exception) : super(exception);
  String get message {
    return exception.toString();
  }
}
