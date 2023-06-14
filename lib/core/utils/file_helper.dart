import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class FileHelper {
  Future<String> getApplicationDocumentsDirectoryPath();

  Future<File> getFileFromUrl(String url);

  Future<MultipartFile> convertFileToMultipartFile(File file);
}

class FileHelperImpl implements FileHelper {
  @override
  Future<String> getApplicationDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Future<File> getFileFromUrl(String url) async {
    final dir = await getApplicationDocumentsDirectoryPath();
    final file = File('$dir/${basename(url)}');

    return file;
  }

  @override
  Future<MultipartFile> convertFileToMultipartFile(File file) {
    // TODO: implement convertFileToMultipartFile
    throw UnimplementedError();
  }
}
