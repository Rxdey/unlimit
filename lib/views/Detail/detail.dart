import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unlimit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/public/public.dart';

class Detail extends StatefulWidget {
  final String id;
  Detail({Key key, this.id}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  AnimaInfo animaInfo;
  List<String> chapterList;
  List<ChapterDetail> chapterDetail;
  List<String> tempList;
  Map orderInfo;
  int isCollect = 0;
  int limit = 14;
  int active = -1;
  String userId = '1';
  String username = 'jyh1994@qq.com';
  @override
  void initState() {
    super.initState();
    _geDetail();
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
      chapterDetail = res.data.chapterDetail;
      orderInfo = res.data.orderInfo;
      isCollect = orderInfo != null ? orderInfo['isShow'] : 0;
      active = orderInfo != null ? orderInfo['last_chapter'] : -1;
      int len = this.chapterList.length;
      tempList = chapterList;
      if (len > limit + 2) {
        tempList = this.chapterList.sublist(0, this.limit);
        tempList.add('...');
        tempList.add(this.chapterList[len - 1]);
      }
      handleCollect(1);
    });
    print(orderInfo);
  }

  Future<void> handleCollect(int state) async {
    var json = await Model.collect({
      'userId': userId,
      'username': username,
      'manhua': widget.id,
      'cover': animaInfo.cover,
      'name': animaInfo.name,
      'state': state
    });
    ResponseStringData res = ResponseStringData.fromJson(json);
    if (state == 2)
      Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
    if (res.state == 0) return;
    setState(() {
      isCollect = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '全部章节 (' +
        (animaInfo != null ? animaInfo.chapter.toString() : '0') +
        ')';
    return Scaffold(
      body: Scrollbar(
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
                    animaInfo != null ? _desc() : Container(),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(title, style: TextStyle(fontSize: 14.0)),
                    ),
                    tempList != null ? _chapters(context) : Container(),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(30.0, 8.0, 15.0, 8.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey[100], blurRadius: 5.0, spreadRadius: 5.0)
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
                    color: isCollect == 1 ? Colors.orange : Colors.black26,
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(60)),
                child: Text(
                  '开始阅读',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      height: 270.0,
      child: animaInfo != null
          ? ClipRect(
              child: FadeInImage.assetNetwork(
                placeholder: 'lib/assets/image/v.png',
                image: animaInfo.cover,
                fit: BoxFit.contain,
              ),
            )
          : Text('加载失败'),
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
                Text('作者: ' + animaInfo.author,
                    style: TextStyle(fontSize: 14.0, color: Colors.black54)),
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
      padding: EdgeInsets.all(10.0),
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
                  if (item == '...') {
                    this._showModalBottomSheet(context);
                    return;
                  }
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  //   return Reader(url: item['url']);
                  // }));
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
