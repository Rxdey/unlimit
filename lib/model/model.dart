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

class Model {
  // static Interface search = Interface(url: '/anima/search'); // 搜索
  static var search = (Map<String, dynamic> data) =>
      HttpRequest.request(Interface(url: '/anima/search'), data);
}
