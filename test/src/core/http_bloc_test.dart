import 'package:sparkrook/src/core/spark_bloc.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_data/mock_comments.dart';
import '../../mock_data/mock_models.dart';
import 'http_bloc_test_data.dart';

void main() {
  final SparkBloc<List<MockComments>> mockCommentBloc =
      SparkBloc<List<MockComments>>();
  final SparkBloc<List<MockComments>> mockCommentBlocFailure =
      SparkBloc<List<MockComments>>();

  group(
    'group: SparkBloc data type checks',
    () {
      test(
        'test: the bloc runtimeType should be the one declared',
        () {
          expect(HttpBlocTestData.mockModelBlocSuccess.runtimeType,
              SparkBloc<MockModelPrimary>);
        },
      );
      test(
        'test: the stream runtimeType should be the one declared with Bloc',
        () {
          expect(
              HttpBlocTestData.mockModelBlocSuccess.httpStream.runtimeType
                  .toString(),
              "_ControllerStream<RookState<MockModelPrimary>>");
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
        'should emit instance of [RookState.loading(),RookState.dataReceived([])]',
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
                RookState<List<MockComments>>.loading(),
                RookState<List<MockComments>>.dataReceived([])
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
                RookState<List<MockComments>>.loading(),
                isInstanceOf<RookState<List<MockComments>>>(),
              ],
            ),
          );
        },
      );
    },
  );
}
