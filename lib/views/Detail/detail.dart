import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:unlimit/components/iconfont.dart';
import 'package:unlimit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/public/public.dart';
import 'package:unlimit/views/Reader/reader.dart';

class Detail extends StatefulWidget {
  final String id;
  Detail({Key key, this.id}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  AnimaInfo animaInfo;
  List<String> chapterList;
  // List<ChapterDetail> chapterDetail;
  List<String> tempList;
  // Map orderInfo;
  int isCollect = 0;
  int limit = 14;
  int active = -1;
  int lastPage = 0;
  String lastChapterName = '-';
  @override
  void initState() {
    super.initState();
    _geDetail();
  }

  @override
  void deactivate() {
    super.deactivate();
    this._getOrderInfo();
  }

  List getTempList(List list, int i) {
    int len = list.length;
    List tempArray;
    if (len > i + 2) {
      tempArray = list.sublist(0, limit);
      tempArray.add('...');
      tempArray.add(list[len - 1]);
    }
    return tempArray;
  }

  Future<void> _geDetail() async {
    var data = await Model.detail({'id': widget.id});
    DetailData res = DetailData.fromJson(data);
    if (res.state == 0) {
      Fluttertoast.showToast(
          msg: res.msg, textColor: Colors.red, gravity: ToastGravity.CENTER);
      return false;
    }
    setState(() {
      animaInfo = res.data.animaInfo;
      chapterList = res.data.chapterList;
      // chapterDetail = res.data.chapterDetail;
      tempList = getTempList(chapterList, limit);
      handleCollect(1);
      _getOrderInfo();
    });
  }

  Future<void> _getOrderInfo() async {
    var json = await Model.getRecord(
        {'manhua': widget.id, 'st': new DateTime.now().millisecondsSinceEpoch});
    ResponseStringData res = ResponseStringData.fromJson(json);
    if (res.state == 0) {
      // Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
      print('异常: ' + res.msg);
      return;
    }
    setState(() {
      isCollect = res.data != null ? res.data['isShow'] : 0;
      active = res.data != null ? res.data['last_chapter'] : -1;
      lastPage = res.data != null ? res.data['last_page'] : 0;
      lastChapterName = res.data != null ? res.data['last_chapter_name'] : '-';
    });
    print('记录信息: ' + res.data.toString());
  }

  Future<void> handleCollect(int state) async {
    var json = await Model.collect({
      'manhua': widget.id,
      'cover': animaInfo.cover,
      'name': animaInfo.name,
      'state': state,
      'st': new DateTime.now().millisecondsSinceEpoch
    });
    ResponseStringData res = ResponseStringData.fromJson(json);
    if (state == 2)
      Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
    if (res.state == 0) return;
    setState(() {
      isCollect = res.data;
    });
  }

  Future<void> _chaperClick(int key, String name) async {
    if (name == '...') {
      this._showModalBottomSheet(context);
      return;
    }
    var json = await Model.update({
      'manhua': widget.id,
      'lastChapter': key,
      'lastChapterName': name,
      'lastPage': 0,
      'st': new DateTime.now().millisecondsSinceEpoch
    });
    ResponseData res = ResponseData.fromJson(json);
    if (res.state == 0) {
      Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
      print('异常: ' + res.msg);
      return;
    }
    setState(() {
      active = key;
    });
    this._goToReader();
  }

  _goToReader() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Reader(id: widget.id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    String title = '全部章节 (' +
        (animaInfo != null ? animaInfo.chapter.toString() : '0') +
        ')';
    return Scaffold(
      body: chapterList == null
          ? Container(
              alignment: Alignment.center,
              child: Text(
                '加载中...',
                style: TextStyle(color: Colors.blue[300]),
              ),
            )
          : Scrollbar(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _cover(),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          _desc(),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(title, style: TextStyle(fontSize: 14.0)),
                              ],
                            ),
                          ),
                          _chapters(context),
                          Padding(
                            padding: EdgeInsets.all(30.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: chapterList != null
          ? Container(
              padding: EdgeInsets.fromLTRB(30.0, 8.0, 15.0, 8.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey[100], blurRadius: 5.0, spreadRadius: 5.0)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      handleCollect(2);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color:
                              isCollect == 1 ? Colors.orange : Colors.black26,
                          size: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(isCollect == 1 ? '已追漫' : '追漫'),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (active == -1) {
                        _chaperClick(0, chapterList[0]);
                        return;
                      }
                      _goToReader();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(60)),
                      child: Text(
                        active == -1 ? '开始阅读' : '继续阅读(' + lastChapterName + ')',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget _cover() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      height: 270.0,
      child: ClipRect(
        child: FadeInImage.assetNetwork(
          placeholder: 'lib/assets/image/v.png',
          image: animaInfo.cover,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _desc() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.only(top: 10.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(animaInfo.name,
                maxLines: 2, style: TextStyle(fontSize: 20.0)),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('作者: ' + animaInfo.author,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0, color: Colors.black54)),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text('·')),
                Text('状态: ' + animaInfo.status,
                    style:
                        TextStyle(fontSize: 14.0, color: Colors.orangeAccent)),
              ],
            ),
          ),
          Text(animaInfo.desc,
              maxLines: 4,
              style: TextStyle(fontSize: 13.0, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _chapters(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: _createChaper(tempList, context),
      ),
    );
  }

  List<Widget> _createChaper(List array, BuildContext context) {
    return array
        .asMap()
        .map((key, item) => MapEntry(
            key,
            Container(
              child: InkWell(
                onTap: () {
                  _chaperClick(key, item);
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    width: 84.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: active == key
                                ? Colors.blue[300]
                                : Colors.black12,
                            width: 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color:
                            active == key ? Colors.blue[300] : Colors.black87,
                      ),
                    )),
              ),
            )))
        .values
        .toList();
  }

  void _showModalBottomSheet(BuildContext context, {Widget child}) {
    Widget chapers = SingleChildScrollView(
      child: Container(
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: this._createChaper(chapterList, context),
        ),
      ),
    );
    bool loading = false;
    child = child ?? chapers;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  // width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.black12, width: 1.0))),
                  child: Text(
                    '全部章节',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: loading
                          ? Text(
                              '加载中...',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            )
                          : child,
                    ))
              ],
            ),
          );
        });
  }
}
