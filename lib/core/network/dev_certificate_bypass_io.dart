import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Mobile/desktop only: ASP.NET Core's local HTTPS dev certificate is
/// self-signed. Windows/macOS trust it via `dotnet dev-certs https
/// --trust`, but Android emulators and iOS simulators don't — every
/// request would fail with a handshake error otherwise.
///
/// Only bypasses validation in debug builds, and only for loopback-ish
/// hosts (localhost / 10.0.2.2 / private LAN ranges), so this can never
/// silently accept a bad certificate from a real production host.
void configureDevCertificateBypass(Dio dio) {
  if (!kDebugMode) return;

  final adapter = dio.httpClientAdapter;
  if (adapter is! IOHttpClientAdapter) return;

  adapter.createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => _isLocalDevHost(host);
    return client;
  };
}

bool _isLocalDevHost(String host) {
  return host == 'localhost' ||
      host == '127.0.0.1' ||
      host == '10.0.2.2' ||
      host.startsWith('192.168.') ||
      host.startsWith('10.') ||
      RegExp(r'^172\.(1[6-9]|2\d|3[0-1])\.').hasMatch(host);
}
