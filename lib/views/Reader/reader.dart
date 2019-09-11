import 'package:flutter/material.dart';

class ChaperDetail {
  int index; // 当前章节
  String name; // 章节名字
  int currentIndex; // 图片位置
  ChaperDetail({this.index, this.name, this.currentIndex});
}

class Reader extends StatefulWidget {
  final List chaperList; // 章节图片列表
  final ChaperDetail chaperDetail; // 当前章节信息
  Reader({Key key, this.chaperList, this.chaperDetail}) : super(key: key);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text('reader')),
    );
  }
}
