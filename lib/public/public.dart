import 'package:flutter/material.dart';

class TabList {
  String name;
  String key;
  Icon icon;
  Widget page;
  TabList({this.name, this.key, this.icon, this.page});
}

class DetailData {
  int state;
  String msg;
  Data data;

  DetailData({this.state, this.msg, this.data});

  DetailData.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<String> chapterList;
  AnimaInfo animaInfo;
  List<ChapterDetail> chapterDetail;
  // Map orderInfo;

  Data({this.chapterList, this.animaInfo, this.chapterDetail});

  Data.fromJson(Map<String, dynamic> json) {
    chapterList = json['chapterList'].cast<String>();
    animaInfo = json['animaInfo'] != null
        ? new AnimaInfo.fromJson(json['animaInfo'])
        : null;
    // orderInfo = json['orderInfo'] != null ? json['orderInfo'] : null;
    if (json['chapterDetail'] != null) {
      chapterDetail = new List<ChapterDetail>();
      json['chapterDetail'].forEach((v) {
        chapterDetail.add(new ChapterDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterList'] = this.chapterList;
    if (this.animaInfo != null) {
      data['animaInfo'] = this.animaInfo.toJson();
    }
    if (this.chapterDetail != null) {
      data['chapterDetail'] =
          this.chapterDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnimaInfo {
  String id;
  String name;
  String chapter;
  String status;
  String author;
  String desc;
  String type;
  String lastUpdata;
  String cover;

  AnimaInfo(
      {this.id,
      this.name,
      this.chapter,
      this.status,
      this.author,
      this.desc,
      this.type,
      this.lastUpdata,
      this.cover});

  AnimaInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    chapter = json['chapter'];
    status = json['status'];
    author = json['author'];
    desc = json['desc'];
    type = json['type'];
    lastUpdata = json['lastUpdata'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['chapter'] = this.chapter;
    data['status'] = this.status;
    data['author'] = this.author;
    data['desc'] = this.desc;
    data['type'] = this.type;
    data['lastUpdata'] = this.lastUpdata;
    data['cover'] = this.cover;
    return data;
  }
}

class ChapterDetail {
  String totle;
  String current;
  List<String> list;

  ChapterDetail({this.totle, this.current, this.list});

  ChapterDetail.fromJson(Map<String, dynamic> json) {
    totle = json['totle'];
    current = json['current'];
    // list = json['list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totle'] = this.totle;
    data['current'] = this.current;
    // data['list'] = this.list;
    return data;
  }
}
