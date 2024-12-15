import 'dart:io';
import 'dart:convert';

class FileService {
  final String filePath;

  FileService(this.filePath);

  Future<void> writeToFile(dynamic data) async {
    final file = File(filePath);
    await file.writeAsString(jsonEncode(data), mode: FileMode.writeOnly);
  }

  Future<dynamic> readFromFile() async {
    final file = File(filePath);
    if (!await file.exists()) return null;
    return jsonDecode(await file.readAsString());
  }

  Future<void> backupFile(String backupPath) async {
    final file = File(filePath);
    final backupFile = File(backupPath);
    if (await file.exists()) {
      await backupFile.writeAsBytes(await file.readAsBytes());
    }
  }
}
