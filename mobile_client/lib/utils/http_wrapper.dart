import 'dart:io';
import 'package:flutter/services.dart';

Future<HttpClient> createHttpClient() async {
  final securityContext = SecurityContext(withTrustedRoots: false);
  final cert = await rootBundle.load('assets/ca-cert.pem');
  securityContext.setTrustedCertificatesBytes(cert.buffer.asUint8List());
  return HttpClient(context: securityContext);
}

