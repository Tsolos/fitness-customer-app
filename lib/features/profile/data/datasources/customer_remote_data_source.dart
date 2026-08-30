import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerModel> getCustomerBasicInfo(String customerId);

  Future<CustomerModel> updateCustomerBasicInfo(Map<String, dynamic> body);

  /// Returns the freshly-uploaded photo's URL (a 24h SAS URL — see
  /// `CustomersController.UploadAvatar`).
  Future<String> uploadAvatar({required String customerId, required Uint8List bytes, required String fileName});
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  CustomerRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CustomerModel> getCustomerBasicInfo(String customerId) async {
    try {
      final response = await _dio.get(ApiEndpoints.customerBasicInfo(customerId));
      return CustomerModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<CustomerModel> updateCustomerBasicInfo(Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(ApiEndpoints.updateCustomerBasicInfo, data: body);
      return CustomerModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<String> uploadAvatar({required String customerId, required Uint8List bytes, required String fileName}) async {
    try {
      final formData = FormData.fromMap({
        'customerID': customerId,
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });
      final response = await _dio.post(ApiEndpoints.uploadCustomerPhoto, data: formData);
      return (response.data as Map<String, dynamic>)['url'] as String;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
