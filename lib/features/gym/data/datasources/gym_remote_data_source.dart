import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/gym_model.dart';

abstract class GymRemoteDataSource {
  Future<List<GymModel>> getGyms();
}

class GymRemoteDataSourceImpl implements GymRemoteDataSource {
  GymRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<GymModel>> getGyms() async {
    try {
      final response = await _dio.get(ApiEndpoints.gyms);
      final list = response.data as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(GymModel.fromJson).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
