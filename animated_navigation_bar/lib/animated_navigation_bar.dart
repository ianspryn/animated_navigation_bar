import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Function onBarTap;
  final int animationTime;

  AnimatedBottomBar({this.barItems, this.onBarTap, this.animationTime = 400});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

const Color PINK = Color(0xFFe34288);

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  double _selectorWidth = 0;

  AnimationController _animationController;
  Tween<double> _positionTween;
  Animation<double> _positionAnimation;

  List<GlobalKey> _keys = List();
//  List<double> _selectorWidth = List();

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback(_afterLayout);
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.animationTime));
    _positionTween = Tween<double>(begin: 0, end: 0);
    _positionAnimation = _positionTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo))
      ..addListener(() {
        setState(() {});
      });
    _positionTween.begin = -1;

    for (int i = 0; i < widget.barItems.length; i++) {
      _keys.add(GlobalKey());
    }
  }

  _afterLayout(_) {
    _setSelectorWidth();
//    for (int i = 0; i < widget.barItems.length; i++) {
//      final RenderBox _renderBoxTab =
//          _keys[i].currentContext.findRenderObject();
//      double _width = _renderBoxTab.size.width;
//      _barWidth.add(_width);
//      print("INDEX: " + i.toString() + " " + _width.toString());
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Colors.white,
//          boxShadow: [
//            BoxShadow(
//                color: Colors.black.withOpacity(0.00),
//                offset: Offset(0, -5),
//                blurRadius: 15)
//          ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
        child: Stack(
          children: <Widget>[
            IgnorePointer(
              child: Container(
                child: Align(
                  alignment: Alignment(_positionAnimation.value, 0),
                  child: AnimatedContainer(
                    height: 40,
                    width: _selectorWidth,
                    duration: Duration(milliseconds: widget.animationTime),
                    curve: Curves.easeOutExpo,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: PINK,
                        boxShadow: [
                          BoxShadow(
                              color: PINK.withOpacity(0.6), blurRadius: 15)
                        ]),
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildBarItems(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      var item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedBarIndex = i;
              widget.onBarTap(selectedBarIndex);
              _initAnimationAndStart(_positionAnimation.value, i - 1.0);
              _setSelectorWidth();
            });
          },
          child: Container(
            key: _keys[i],
            child: Padding(
              padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Icon(item.iconData, color: isSelected ? Colors.white : PINK),
                  if (isSelected) SizedBox(width: 15),
                  if (isSelected)
                    Text(
                      item.text,
                      style: TextStyle(color: Colors.white),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return _barItems;
  }

  _setSelectorWidth() {
    final RenderBox _renderBoxTab =
    _keys[selectedBarIndex].currentContext.findRenderObject();
    _selectorWidth = _renderBoxTab.size.width;
  }

  _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _animationController.forward();
  }
}

class BarItem {
  IconData iconData;
  String text;

  BarItem(this.iconData, this.text);
}
