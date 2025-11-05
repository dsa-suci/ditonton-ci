import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

/// Kelas untuk membuat HTTP client dengan SSL pinning
/// menggunakan sertifikat lokal dan verifikasi fingerprint SHA256.
class SSLPinning {
  /// Membuat http.Client dengan SSL pinning.
  ///
  /// [allowedHost] = host yang diperbolehkan, misal 'api.themoviedb.org'
  /// [expectedFingerprint] = fingerprint SHA256 sertifikat server (hex, tanpa spasi)
  static Future<http.Client> createSSLPinnedClient({
    required String allowedHost,
    required String expectedFingerprint,
  }) async {
    // Load sertifikat dari assets
    final sslCert = await rootBundle.load('certificates/certificates.pem');

    // Buat SecurityContext tanpa root bawaan
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    final httpClient = HttpClient(context: context);

    // Callback untuk memverifikasi sertifikat server
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          if (host != allowedHost) return false;

          // Hitung SHA256 fingerprint dari sertifikat server
          final der = cert.der;
          final sha256Digest = sha256.convert(der).toString().toUpperCase();

          // Bandingkan dengan fingerprint yang diharapkan
          return sha256Digest == expectedFingerprint.toUpperCase();
        };

    return IOClient(httpClient);
  }
}
