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
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _cover(),
            animaInfo != null ? _desc() : Container(),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                  '全部章节 (' +
                      (animaInfo != null ? animaInfo.chapter.toString() : '0') +
                      ')',
                  style: TextStyle(fontSize: 16.0)),
            ),
            chapterList != null ? _chapters(context) : Container(),
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
                    style: TextStyle(fontSize: 14.0, color: Colors.black87)),
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
      children: _createChaper(chapterList, context),
    ),
    );
  }

  List<Widget> _createChaper(List array, BuildContext context) {
    return array.asMap().map((key, item) => MapEntry(key,Container(
              child: InkWell(
                onTap: () {
                  // if (item['url'] == 'more') {
                  //   this._showModalBottomSheet(context);
                  //   return;
                  // }
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  //   return Reader(url: item['url']);
                  // }));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 82.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200], width: 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    )),
              ),
            )))
        .values
        .toList();
  }
}
