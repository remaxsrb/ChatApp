import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:mobile_client/utils/http_wrapper.dart' show createHttpClient;

Future<String> uploadPhoto(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) {
    return '';
  }

  try {
    final httpClient = await createHttpClient();
    final client = io_client.IOClient(httpClient);

    // Create multipart request
    final uri = Uri.https('localhost.local', 'file/upload');
    final request = http.MultipartRequest('POST', uri);

    // Add file to request
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final fileName = file.uri.pathSegments.last;
    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      filePath,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    );
    request.files.add(multipartFile);

    // Send request
    final response = await client.send(request);
    final responseBody = await response.stream.bytesToString();

    // Close client
    client.close();

    if (response.statusCode == 200) {
      final json = jsonDecode(responseBody);
      return json['fileURL'] ?? '';
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}
