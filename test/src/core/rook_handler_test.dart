import 'package:sparkrook/src/core/rook_handler.dart';
import 'package:sparkrook/src/core/rook_state.dart';
import 'package:sparkrook/src/src_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_data/mock_comments.dart';
import '../../mock_data/mock_models.dart';
import 'rook_handler_test_data.dart';

void main() {
  final RookHandler<List<MockComments>> mockCommentBloc =
      RookHandler<List<MockComments>>();
  final RookHandler<List<MockComments>> mockCommentBlocFailure =
      RookHandler<List<MockComments>>();

  group(
    'group: RookHandler data type checks',
    () {
      test(
        'test: the bloc runtimeType should be the one declared',
        () {
          expect(HttpBlocTestData.mockModelBlocSuccess.runtimeType,
              RookHandler<MockModelPrimary>);
        },
      );
      test(
        'test: the stream runtimeType should be the one declared with Bloc',
        () {
          expect(
              HttpBlocTestData.mockModelBlocSuccess.rook.runtimeType.toString(),
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
            mockCommentBloc.rook,
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
            mockCommentBlocFailure.rook,
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
