import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Share {
  static const MethodChannel _channel = const MethodChannel(
      'channel:github.com/orgs/esysberlin/esys-flutter-share');

  /// Sends a text to other apps.
  static Future<int> text(String title, String text, String mimeType) async {
    Map argsMap = <String, String>{
      'title': '$title',
      'text': '$text',
      'mimeType': '$mimeType'
    };
    var result = await _channel.invokeMethod('text', argsMap);
    return result;
  }

  /// Sends a file to other apps.
  static Future<int> file(
      String title, String name, List<int> bytes, String mimeType,
      {String text = ''}) async {
    Map argsMap = <String, String>{
      'title': '$title',
      'name': '$name',
      'mimeType': '$mimeType',
      'text': '$text'
    };

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$name').create();
    await file.writeAsBytes(bytes);

    var result = await _channel.invokeMethod('file', argsMap);
    return result;
  }

  /// Sends multiple files to other apps.
  static Future<int> files(
      String title, Map<String, List<int>> files, String mimeType,
      {String text = ''}) async {
    Map argsMap = <String, dynamic>{
      'title': '$title',
      'names': files.entries.toList().map((x) => x.key).toList(),
      'mimeType': mimeType,
      'text': '$text'
    };

    final tempDir = await getTemporaryDirectory();

    for (var entry in files.entries) {
      final file = await new File('${tempDir.path}/${entry.key}').create();
      await file.writeAsBytes(entry.value);
    }

    var result = await _channel.invokeMethod('files', argsMap);
    return result;
  }
}
