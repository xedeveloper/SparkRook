import 'package:dio/dio.dart';

/// Helper class to get the [Dio] client with default
/// configuration to make the API call
class NetworkHelper {
  static const ACCEPT_HEADER = "Accept";

  /// Returns [Dio] client with default configuration
  /// like Timeouts with 300 seconds.
  /// & options header as "application/json"
  static Dio getDioClient() {
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 300),
        receiveTimeout: Duration(seconds: 300),
      ),
    );
    dio.options.headers[ACCEPT_HEADER] = "application/json";
    return dio;
  }
}
