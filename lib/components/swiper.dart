import 'package:flutter/material.dart';

class Swiper extends StatefulWidget {
  final List<String> imgList;
  final bool reverse;
  final Function onEnd;
  Swiper({this.imgList, this.reverse = true, this.onEnd, Key key}) : super(key: key);
  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  int count = 0;
  PageController _pageController;
  // int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      count = widget.imgList.length;
    });
  }

  _onPageChanged(index) {
    if (index == count - 1) {
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          reverse: widget.reverse,
          itemCount: count,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                widget.imgList[index],
                scale: 1.0,
              ),
            );
          }),
    );
  }
}
