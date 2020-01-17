import 'dart:io';
import 'package:alpha_task/database/db_manager.dart';
import 'package:alpha_task/model/circuit.dart';
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
    print(exist);
    if (!exist) {
      file.create();
    }
    return file;
  }

  //Todo: load image from network
  Future<File> loadImage(String url) async {
    try {
      await createDir();
      Directory localDirectory = await getApplicationDocumentsDirectory();
      String localPath = localDirectory.path;
      String dbPath = localPath + '/images';
      List<String> splitUrl = url.split('/');
      String fileName = splitUrl[splitUrl.length - 2] + '_' + splitUrl[splitUrl.length - 1];
      String filePath = dbPath + '/' + fileName;
      File file = new File(filePath);
      if (await file.exists() == false) {
        file = await createFile(filePath);
        try {
          var response = await http.get(url);
          file.writeAsBytes(response.bodyBytes);
          print(response.bodyBytes.length);
        } catch (e) {
          print(e);
          return null;
        }
      }
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //ToDo: load sites list images
  Future<int> loadSitesImages(Circuit circuit, Function callBack) async {
    DbManager dbManager = new DbManager();
    int sum = 0;

    for (int i = 0; i < circuit.sites.length; i++) {
      for (int j = 0; j < circuit.sites[i].images.length; j++) {
        if (circuit.sites[i].images[j].localPath == null) {
          await loadImage(circuit.sites[i].images[j].imgPath).then((onValue) async {
            if (onValue != null) {
              if (await onValue.exists()) {
                print("${onValue.path} --- ${onValue.readAsBytesSync().length}");
                if (circuit.sites[i].images[j].localPath != onValue.path) {
                  circuit.sites[i].images[j].localPath = onValue.path;
                  sum++;
                }
              }
            }
          });
          callBack();
        }
        //Function.apply(callBack, null);
      }
    }
    await dbManager.updateCircuit(circuit);
    return sum;
  }
}
