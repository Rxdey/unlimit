import 'package:unlimit/request/request.dart';

// const HOST = 'http://45.76.203.52:9088/mock/21';
class ResponseData {
  String msg;
  List data;
  int state;
  ResponseData({this.msg, this.data, this.state});
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
        msg: json['msg'], data: json['data'], state: json['state']);
  }
}

class ResponseStringData {
  String msg;
  dynamic data;
  int state;
  ResponseStringData({this.msg, this.data, this.state});
  factory ResponseStringData.fromJson(Map<String, dynamic> json) {
    return ResponseStringData(
        msg: json['msg'], data: json['data'], state: json['state']);
  }
}

class Model {
  static var search = (Map<String, dynamic> data) =>
      HttpRequest.request(Interface(url: '/anima/search'), data); // 搜索
  static var save = (Map<String, dynamic> data) =>
      HttpRequest.request(Interface(url: '/anima/save'), data); // 订阅记录
  static var detail = (Map<String, dynamic> data) =>
      HttpRequest.request(Interface(url: '/anima/detail'), data); // 详情
  static var collect = (Map<String, dynamic> data) => HttpRequest.request(
      Interface(url: '/anima/collect'), data); // 添加历史记录/订阅/取消订阅
  static var update = (Map<String, dynamic> data) => HttpRequest.request(Interface(url: '/anima/update'), data); // 更新记录
  static var getRecord = (Map<String, dynamic> data) => HttpRequest.request(Interface(url: '/anima/getRecord'), data); // 获取记录
}
