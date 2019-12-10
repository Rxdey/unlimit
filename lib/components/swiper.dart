import 'package:flutter/material.dart';
import 'package:unlimit/components/preload_page_view.dart';

class Swiper extends StatefulWidget {
  final List imgList;
  final bool reverse;
  final Function onChange;
  final Function contentTap;
  final int initialPage;
  final int page;
  Swiper({this.imgList, this.reverse = true, this.onChange, this.contentTap, this.initialPage = 0, this.page = 0, Key key}) : super(key: key);
  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  PreloadPageController _pageController;
  // int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _pageController = PreloadPageController(initialPage: widget.initialPage);
    });
  }

  _onPageChanged(index) {
    widget.onChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PreloadPageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          reverse: widget.reverse,
          itemCount: widget.imgList.length,
          preloadPagesCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.contentTap(index, widget.imgList[index], widget.imgList);
              },
              child: Container(
                color: Colors.black87,
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  widget.imgList[index]['url'],
                  scale: 1.0,
                ),
              ),
            );
          }),
    );
  }
}
