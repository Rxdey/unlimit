import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/util/util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:unlimit/views/Login/login.dart';
// import 'package:unlimit/api/api.dart';

const HOST = 'http://45.76.203.52:9006';
// const HOST = 'http://yapi.rxdey.xyz/mock/21';
// const HOST = 'http://10.255.74.163:9006';

/*
 * 封装 restful 请求
 * 
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */

class Interface {
  String url;
  String method;
  String baseUrl;
  Interface({this.url, this.method = 'get', this.baseUrl = HOST});
}

class HttpRequest {
  /// global dio object
  static Dio dio;

  /// default options
  // static const String API_PREFIX = ''; // base 地址
  static const int CONNECT_TIMEOUT = 600000;
  static const int RECEIVE_TIMEOUT = 30000;

  /// http request methods
  static const String GET = 'GET';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// request method
  static Future<Map> request(Interface config, Map<String, dynamic> data) async {
    data = data ?? {};
    String method = config.method ?? 'GET';
    String url = config.url ?? '';
    String baseUrl = config.baseUrl ?? '';

    String userName = await getStringItem('userName');
    String userId = await getStringItem('userId');

    if (userName != null && data['username'] == null) data['username'] = userName;
    if (userId != null && data['userId'] == null) data['userId'] = userId;

    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    print('请求地址：【' + method + '  ' + baseUrl + url + '】');
    print('请求参数：' + data.toString());

    Dio dio = createInstance(baseUrl);
    var result;
    try {
      Response response;
      if (method.toLowerCase() == 'get') {
        response = await dio.get(url, queryParameters: data);
      }
      if (method.toLowerCase() == 'post') {
        response = await dio.post(url, data: data);
      }
      result = response.data;
      print('状态：' + response.data['state'].toString());
    } on DioError catch (e) {
      print('请求出错：' + e.toString());
      Fluttertoast.showToast(msg: '网络异常', textColor: Colors.red, gravity: ToastGravity.CENTER);
      result['state'] = 0;
    }
    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance(String baseUrl) {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);
    }
    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
