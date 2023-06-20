import 'package:rebuilder/src/core/http_bloc.dart';
import 'package:rebuilder/src/core/http_connection_state.dart';
import 'package:rebuilder/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_data/mock_comments.dart';
import '../../mock_data/mock_models.dart';
import 'http_bloc_test_data.dart';

void main() {
  final HttpBloc<List<MockComments>> mockCommentBloc =
      HttpBloc<List<MockComments>>();
  final HttpBloc<List<MockComments>> mockCommentBlocFailure =
      HttpBloc<List<MockComments>>();

  group(
    'group: HttpBloc data type checks',
    () {
      test(
        'test: the bloc runtimeType should be the one declared',
        () {
          expect(HttpBlocTestData.mockModelBlocSuccess.runtimeType,
              HttpBloc<MockModelPrimary>);
        },
      );
      test(
        'test: the stream runtimeType should be the one declared with Bloc',
        () {
          expect(
              HttpBlocTestData.mockModelBlocSuccess.httpStream.runtimeType
                  .toString(),
              "_ControllerStream<HttpConnectionState<MockModelPrimary>>");
        },
      );
    },
  );

  group(
    'group: stream controller test cases success',
    () {
      Dio _dioClient = Dio();
      setUp(
        () {
          _dioClient.httpClientAdapter = HttpBlocTestData.mockAdapterSuccess;
          _dioClient.options = BaseOptions(
            method: "GET",
            baseUrl: "https://testing.api.com",
          );
        },
      );
      test(
        'should emit instance of [HttpConnectionState.loading(),HttpConnectionState.dataReceived([])]',
        () {
          mockCommentBloc.initiateHttpRequest<MockComments>(
            method: HttpMethod.GET,
            dio: _dioClient,
            url: "https://testing.api.com",
            parser: MockComments.fromJson,
          );
          expectLater(
            mockCommentBloc.httpStream,
            emitsInOrder(
              [
                HttpConnectionState<List<MockComments>>.loading(),
                HttpConnectionState<List<MockComments>>.dataReceived([])
              ],
            ),
          );
        },
      );
    },
  );

  group(
    'group: stream controller test cases failure',
    () {
      Dio _dioClient = Dio();
      setUp(
        () {
          _dioClient.httpClientAdapter = HttpBlocTestData.mockAdapterFailure;
          _dioClient.options = BaseOptions(
            method: "GET",
            baseUrl: "https://testing.api.com",
          );
        },
      );
      test(
        'should emit instance of Future<MockModelPrimary>',
        () {
          mockCommentBlocFailure.initiateHttpRequest<MockComments>(
            method: HttpMethod.GET,
            dio: _dioClient,
            url: "https://testing.api.com",
            parser: MockComments.fromJson,
          );

          expectLater(
            mockCommentBlocFailure.httpStream,
            emitsInOrder(
              [
                HttpConnectionState<List<MockComments>>.loading(),
                isInstanceOf<HttpConnectionState<List<MockComments>>>(),
              ],
            ),
          );
        },
      );
    },
  );
}
