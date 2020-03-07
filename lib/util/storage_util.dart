import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///本地存储工具
class Storage {
  ///获取本地字符串
  static Future<String> getStr(key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print('get info error:$e');
      return null;
    }
  }

  ///获取本地整型
  static Future<int> getInt(key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    } catch (e) {
      print('get info error:$e');
      return null;
    }
  }

  ///获取键值对列表
  static Future<List<String>> getStrList(key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key);
    } catch (e) {
      print('get info error:$e');
      return null;
    }
  }

  ///保存字符串
  static setStr(key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    } catch (e) {
      print('set info error:$e');
      return null;
    }
  }

  ///保存字符串列表
  static setStrList(key, List<String> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(key, value);
    } catch (e) {
      print('set info error:$e');
      return null;
    }
  }

  ///保存整型
  static setInt(key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value);
    } catch (e) {
      print('set info error:$e');
      return null;
    }
  }

  ///删除键值对
  static delete(key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
    } catch (e) {
      print('remove info error:$e');
      return null;
    }
  }

  ///读取文件
  static readFile(String fileName, String path, String info,
      {String type = 'map'}) async {
    try {
      if (fileName == null || fileName.trim().length == 0) {
        fileName = "defaultuser";
      }
      final File file =
          await _localFile('${await _localPath()}/$path', fileName);
      final String str = await file.readAsString();

      print(
          '$info:读取$path/$fileName---文件大小:${(file.lengthSync() / 1024 / 1024).toStringAsFixed(2)}m');

      return json.decode(str);
    } catch (err) {
      print('$path/$fileName 没有这个文件(￣﹃￣)');

      //没有文件就创建一个
      switch (type) {
        case 'map':
          await writeFile({}, fileName, path, '本地未发现此文件');
          break;
        case 'string':
          await writeFile('', fileName, path, '本地未发现此文件');
          break;
        case 'list':
          await writeFile([], fileName, path, '本地未发现此文件');
          break;
      }

      return null;
    }
  }

  ///写入文件
  static writeFile(obj, String fileName, String path, String info) async {
    try {
      if (fileName == null || fileName.trim().length == 0) {
        fileName = "defaultuser";
      }
      final File file =
          await _localFile('${await _localPath()}/$path', fileName);

      print('$info:写入$path/$fileName成功');

      return await file.writeAsString(json.encode(obj));
    } catch (err) {
      print('$fileName 写入数据出错 : $err');
      writeFile(obj, fileName, path, '写入文件');
      return null;
    }
  }

  ///删除文件
  static deleteFile(String fileName, String path) async {
    try {
      final File file =
          await _localFile('${await _localPath()}/$path', fileName);
      file.delete();
      print('删除文件$fileName');
      return true;
    } catch (err) {
      print('$fileName 删除出错 : $err');
      return null;
    }
  }

  ///文件位置引用
  static _localFile(path, String filename) async {
    File f = await File('$path/$filename').create(recursive: true);
    return f;
  }

  ///使用 path_provider 查找本地路径
  static _localPath() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      return appDocPath;
    } catch (err) {
      print('查找本地路径出错 : $err');
    }
  }
}
