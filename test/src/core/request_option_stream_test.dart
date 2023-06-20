import 'package:rebuilder/src/core/request_option_stream.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_data/mock_models.dart';

void main() {
  group(
    'group: RequestOptionsStream test cases',
    () {
      test(
        'test: the RequestOptions.responseType should be ResponseType.plain if data is in String format',
        () {
          RequestOptions actualRequestOptions =
              RequestOptionsStream.setStreamType<String>(
            RequestOptions(),
          );
          expect(actualRequestOptions.responseType, ResponseType.plain);
        },
      );
      test(
        'test: the RequestOptions.responseType should be ResponseType.json if data is in List format',
        () {
          RequestOptions actualRequestOptions =
              RequestOptionsStream.setStreamType<List<MockModelPrimary>>(
            RequestOptions(),
          );
          expect(actualRequestOptions.responseType, ResponseType.json);
        },
      );
      test(
        'test: the RequestOptions.responseType should be ResponseType.json if data is in Model format',
        () {
          RequestOptions actualRequestOptions =
              RequestOptionsStream.setStreamType<MockModelPrimary>(
            RequestOptions(),
          );
          expect(actualRequestOptions.responseType, ResponseType.json);
        },
      );
    },
  );
}
