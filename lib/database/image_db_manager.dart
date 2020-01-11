import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ImageDbManager {

  //ToDo: create a new image db directory if doesn't exist
  Future<Directory> createDir() async {
    Directory localDirectory = await getApplicationDocumentsDirectory();
    String localPath = localDirectory.path;
    String dbPath = localPath + '/images';
    Directory dbDirectory = new Directory(dbPath);
    bool exist = await dbDirectory.exists();
    if (!exist) {
      new Directory(dbPath).create().then((dir) {
        return dir;
      });
    }
    return null;
  }

  //ToDo: create a new file
  Future<File> createFile(String path) async {
    File file = File(path);
    bool exist = await file.exists();
    if (!exist) {
      file.create();
    }
    return file;
  }


  //Todo: load image from network
  Future<File> loadImage(String url) async {
    Directory localDirectory = await getApplicationDocumentsDirectory();
    String localPath = localDirectory.path;
    String dbPath = localPath + '/images';
    String fileName = url.split('/').last;
    String filePath = dbPath + '/' + fileName;
    File file = await createFile(filePath);
    var response = await http.get(url);
    file.writeAsBytes(response.bodyBytes);
    return file;
  }
}