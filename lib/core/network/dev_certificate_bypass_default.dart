import 'package:dio/dio.dart';

/// Web build: the browser owns TLS validation entirely: there is no way
/// (and no need) for Dart code to override it. The user just has to open
/// the API's `https://localhost:PORT` once and click through Chrome's
/// self-signed-certificate warning.
void configureDevCertificateBypass(Dio dio) {}
