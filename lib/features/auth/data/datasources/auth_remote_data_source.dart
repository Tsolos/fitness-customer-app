import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/auth_response_model.dart';
import '../models/google_login_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);

  Future<AuthResponseModel> googleLogin(GoogleLoginRequestModel request);

  /// Returns the server's (deliberately generic) confirmation message —
  /// there's no token/session yet, the account only becomes usable once
  /// the user taps the link in the verification email.
  Future<String> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: request.toJson());
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> googleLogin(GoogleLoginRequestModel request) async {
    try {
      final response = await _dio.post(ApiEndpoints.googleLogin, data: request.toJson());
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<String> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(ApiEndpoints.register, data: request.toJson());
      final data = response.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return 'Αν το email σας ανήκει σε πελάτη μας, θα λάβετε σύντομα ένα email επιβεβαίωσης.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
