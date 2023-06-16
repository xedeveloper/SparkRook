import 'package:api_widget/src/core/http_bloc.dart';
import 'package:api_widget/src/src_export.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_data/mock_comments.dart';
import '../../mock_data/mock_models.dart';

void main() {
  final HttpBloc<MockModelPrimary> mockModelBloc = HttpBloc<MockModelPrimary>();
  final HttpBloc<List<MockComments>> mockCommentBloc =
      HttpBloc<List<MockComments>>();

  group(
    'group: HttpBloc data type checks',
    () {
      test(
        'test: the bloc runtimeType should be the one declared',
        () {
          expect(mockModelBloc.runtimeType, HttpBloc<MockModelPrimary>);
        },
      );
      test(
        'test: the stream runtimeType should be the one declared with Bloc',
        () {
          expect(mockModelBloc.httpStream.runtimeType.toString(),
              "_ControllerStream<MockModelPrimary>");
        },
      );
    },
  );
  group(
    'group: stream controller test cases',
    () {
      test(
        'should emit instance of Future<MockModelPrimary>',
        () {
          mockCommentBloc.initiateHttpRequest<MockComments>(
            method: HttpMethod.GET,
            url: "https://jsonplaceholder.typicode.com/comments",
            parser: MockComments.fromJson,
          );
          expectLater(
            mockCommentBloc.httpStream,
            emits(
              isInstanceOf<List<MockComments>>(),
            ),
          );
        },
      );
    },
  );
}
