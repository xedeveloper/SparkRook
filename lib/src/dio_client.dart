import 'package:dio/dio.dart';

class NetworkHelper {
  static const ACCEPT_HEADER = "Accept";
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
