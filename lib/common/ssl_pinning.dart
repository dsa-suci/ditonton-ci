import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class SSLPinning {
  static Future<http.Client> createSSLPinnedClient({
    required String allowedHost,
  }) async {
    // Load sertifikat dari assets
    final sslCert = await rootBundle.load('certificates/certificates.pem');

    // Buat context SSL baru tanpa trusted root bawaan
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    // Buat HttpClient
    final httpClient = HttpClient(context: context);

    // Verifikasi host
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      return host == allowedHost;
    };

    return IOClient(httpClient);
  }
}
