import 'package:sparkrook/src/network_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'group: network helper test cases success (Dio Client)',
    () {
      test(
        'test: dio connectionTimout should be 300 seconds',
        () {
          expect(
            NetworkHelper.getDioClient().options.connectTimeout?.inSeconds,
            300,
          );
        },
      );
      test(
        'test: dio receiveTimeout should be 300 seconds',
        () {
          expect(
            NetworkHelper.getDioClient().options.receiveTimeout?.inSeconds,
            300,
          );
        },
      );

      test(
        'test: dio Accept headers should be application/json',
        () {
          expect(
            NetworkHelper.getDioClient().options.headers["Accept"],
            "application/json",
          );
        },
      );
    },
  );
}
