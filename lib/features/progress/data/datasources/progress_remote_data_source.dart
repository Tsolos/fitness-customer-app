import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/progress_entry_model.dart';

abstract class ProgressRemoteDataSource {
  Future<List<ProgressEntryModel>> getAllMeasurements(String customerId);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  ProgressRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProgressEntryModel>> getAllMeasurements(String customerId) async {
    try {
      final response = await _dio.get(ApiEndpoints.allMeasurements(customerId));
      final list = response.data as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(ProgressEntryModel.fromJson).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
