import 'package:flutter/material.dart';
import 'package:unlimit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/public/public.dart';
import 'package:unlimit/components/swiper.dart';

import 'package:unlimit/public/json.dart';

class Reader extends StatefulWidget {
  final String id;
  Reader({Key key, this.id}) : super(key: key);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  int lastPage = 0;
  int lastChapter = 0;
  List<DataList> dataList;
  // DataList currentChapter = DataList.fromJson(listJson);
  DataList currentChapter;
  @override
  void initState() {
    super.initState();
    this._geChaperDetail();
  }

  Future<void> _geChaperDetail() async {
    var json = await Model.getImageUrl({'id': widget.id});
    ChaperDetail res = ChaperDetail.fromJson(json);
    if (res.state == 0) {
      Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
      print('异常: ' + res.msg);
      return;
    }
    setState(() {
      dataList = res.data;
      print('总长度:' + dataList.length.toString());
      this._getRecord();
    });
  }

  Future<void> _getRecord() async {
    var json = await Model.getRecord(
        {'manhua': widget.id, 'st': new DateTime.now().millisecondsSinceEpoch});
    ResponseStringData res = ResponseStringData.fromJson(json);
    if (res.state == 0) {
      print('异常: ' + res.msg);
      return;
    }
    setState(() {
      lastPage = res.data['last_page'] ?? 0;
      lastChapter = res.data != null ? res.data['last_chapter'] : 0;
      currentChapter = dataList[res.data['last_chapter']];
      print(lastChapter);
      print('当前话: ' + currentChapter.current.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          child: currentChapter != null
              ? Swiper(imgList: currentChapter.list, onEnd: () {})
              : Text('加载中...'),
        ),
      ),
    );
  }
}
