import 'package:flutter/material.dart';
import 'package:unlimit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/public/public.dart';
import 'package:unlimit/components/swiper.dart';

// import 'package:unlimit/public/json.dart';

class Reader extends StatefulWidget {
  final String id;
  Reader({Key key, this.id}) : super(key: key);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  int lastPage = 0;
  int lastChapter = 0;
  int currendIndex = 0;
  int currentChapterIndex = 0;
  List<DataList> dataList = [];
  List lastList = [];
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
    int cha = res.data['last_chapter'] > 0 ? res.data['last_chapter'] : 0;
    setState(() {
      lastPage = res.data['last_page'] ?? 0;
      lastChapter = cha;
      currentChapterIndex = cha;
      currentChapter = createImgList(dataList[cha]);
      lastList.addAll(createImgList(dataList[cha]).list);
    });
  }

  handleOnChange(index) {
    // if (index == 0) {
    //   setState(() {
    //     currentChapter = dataList[currentChapterIndex - 1];
    //     if (currentChapterIndex - 1 >= 0) {
    //       lastList.insertAll( 0, createImgList(dataList[currentChapterIndex - 1]).list);
    //     }
    //     currentChapterIndex = currentChapterIndex - 1;
    //   });
    // }
    setState(() {
      currendIndex = index;
    });
    if (index == lastList.length - 1) {
      setNextPage(index);
    }
  }

  handleContentTap(index, img, imglist) {
    // print(img);
  }
// 自动添加下一话 更新记录
  setNextPage(int index) async {
    setState(() {
      currentChapter = createImgList(dataList[currentChapterIndex + 1]);
      lastList.addAll(createImgList(dataList[currentChapterIndex + 1]).list);
      currentChapterIndex = currentChapterIndex + 1;
    });

    var json = await Model.update({
      'manhua': widget.id,
      'lastChapter': currentChapterIndex,
      'lastChapterName': dataList[currentChapterIndex].chapterName,
      'lastPage': 0,
      'st': new DateTime.now().millisecondsSinceEpoch
    });
    ResponseData res = ResponseData.fromJson(json);
    if (res.state == 0) {
      Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
      print('异常: ' + res.msg);
      return;
    }
  }

  DataList createImgList(DataList data) {
    List list = data.list
        .asMap()
        .map((key, item) => MapEntry(key, {
              'current': key + 1,
              'url': item,
              'totle': data.totle,
              'chapterName': data.chapterName
            }))
        .values
        .toList();
    return DataList(totle: data.totle, current: data.current, list: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
            child: lastList.length != 0
                ? Swiper(
                    imgList: lastList,
                    onChange: handleOnChange,
                    contentTap: handleContentTap,
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text('加载中...',
                        style: TextStyle(color: Colors.blue[300], height: 8.0)),
                  )),
      ),
      bottomNavigationBar: Container(
        color: Colors.black87,
        height: 28.0,
        // alignment: Alignment.bottomRight,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.only(
                    left: 18.0, right: 18.0, top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: lastList.length != 0
                          ? Text(lastList[currendIndex]['chapterName'],
                              style: TextStyle(color: Colors.white))
                          : Text('--'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: lastList.length != 0
                          ? Text(
                              lastList[currendIndex]['current'].toString() +
                                  '/' +
                                  lastList[currendIndex]['totle'].toString(),
                              style: TextStyle(color: Colors.white))
                          : Text('1/1'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
