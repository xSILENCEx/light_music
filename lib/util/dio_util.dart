import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:flutter/foundation.dart';
import 'package:light_player/objects/lp_music.dart';

const CONNECT_TIMEOUT = 2000;
const RECEIVE_TIMEOUT = 2000;

class DioUtils {
  /// global dio object
  static Dio dio;

  ///QQ音乐API
  static const String API_PREFIX = 'https://c.y.qq.com/v8/fcg-bin';

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  ///请求方法
  static Future<Map> request(
    String url,
    String info, {
    data = const {},
    method = 'GET',
    bool log = true,
  }) async {
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    ///打印请求内容
    print('开始网络请求 INFO:$info');

    /// 打印请求相关信息:请求地址、请求方式、请求参数
    if (log) print('请求地址:【' + method + ':$API_PREFIX' + url + '】');

    if (data.toString() != '{}') print('请求参数:' + data.toString());

    Dio dio = _createInstance(url);
    dio.transformer = FlutterTransformer();
    String _result;

    try {
      Response response = await dio.request(
        url,
        data: data,
        options: Options(method: method),
      );

      _result = response.data;

      ///如果返回jsonp，截取需要部分
      if (_result.startsWith('callback')) {
        _result = _result.substring(9, _result.length - 1);
      }

      /// 打印响应相关信息
      if (log) print('响应数据:' + _result.toString());
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错:($info)' + e.toString());
      print('失败链接:($url)');
    }

    return json.decode(_result);
  }

  ///获取随机播放列表
  static Future<Map> getRecommendMusic(SourceType type,
      {bool isTop = false}) async {
    final String _top100 =
        "https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8%C2%ACice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=27&_=1519963122923%E3%80%81";
    final String _follow =
        "https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472";

    Map result;
    try {
      switch (type) {
        case SourceType.local:
          break;
        case SourceType.qq:
          result = await request(
            isTop ? _top100 : _follow,
            '获取QQ随机推荐',
            log: false,
          );
          break;
        default:
          break;
      }
    } catch (e) {
      print('获取随机播放列表失败:$e');
    }
    return result ?? {};
  }

  ///搜索音乐
  static Future<Map> searchMusic(SourceType type, String keyWord) async {
    Map result;
    switch (type) {
      case SourceType.qq:
        result = await request(
          'https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=1&n=80&w=$keyWord',
          '获取QQ搜索结果',
          log: false,
        );
        break;
      default:
        break;
    }

    return result;
  }

  ///获取网络图片字节流
  static Future<Uint8List> networkImageToByte(String path) async {
    try {
      final _request = await HttpClient().getUrl(Uri.parse(path));
      final _response = await _request.close();
      Uint8List _bytes = await consolidateHttpClientResponseBytes(_response);

      return _bytes;
    } catch (e) {
      print('解析网路图片失败:$e');
    }

    return null;
  }

  /// 创建 dio 实例对象
  static Dio _createInstance(String baseUrl) {
    if (dio == null) {
      /// 全局属性:请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);
    }

    return dio;
  }

  ///关闭连接
  static close() {
    dio.close();

    print('关闭网络连接');
  }

  /// 清空 dio 对象
  static clear() {
    dio.clear();
    dio = null;
  }
}
