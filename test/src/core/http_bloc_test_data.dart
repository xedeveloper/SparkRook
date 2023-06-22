import 'package:sparkrook/src/core/spark_bloc.dart';

import '../../mock_data/dio_mock_response_adapter.dart';
import '../../mock_data/mock_models.dart';

class HttpBlocTestData {
  static SparkBloc<MockModelPrimary> mockModelBlocSuccess =
      SparkBloc<MockModelPrimary>();
  static DioMockResponseAdapter mockAdapterSuccess = DioMockResponseAdapter(
    MockAdapterInterceptor(
      RequestType.GET,
      "https://testing.api.com",
      "",
      {},
      [],
      200,
    ),
  );

  static DioMockResponseAdapter mockAdapterFailure = DioMockResponseAdapter(
    MockAdapterInterceptor(
      RequestType.GET,
      "https://testing.api.com",
      "",
      {},
      null,
      500,
    ),
  );
}
