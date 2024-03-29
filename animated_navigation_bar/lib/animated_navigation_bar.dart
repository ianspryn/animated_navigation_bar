import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  ///The navigation bar items
  final List<BarItem> barItems;

  ///Triggered every time an item in the navigation bar is tapped
  final Function onBarTap;

  ///The height of the navigation bar
  final double height;

  ///The height of the selector pill
  final double selectorPillHeight;

  ///The animation time of the selector pill moving in **milliseconds**.
  ///
  ///This also effects the animation of item text appearing and disappearing
  final int animationTime;

  ///Determines default starting position of the selector pill
  final int startIndex;

  ///The color to fill the selector pill.
  ///
  ///The glow around the selector pill is also effected by this color.
  final Color color;

  ///Sets the adding on the left and right side
  final int navigationPadding;

  ///The left and right padding between the selector pill and the icon and text inside
  final int selectorPillPadding;

  AnimatedBottomBar(
      {this.barItems,
      this.onBarTap,
      this.height = 85,
      this.selectorPillHeight = 40,
      this.selectorPillPadding = 15,
      this.animationTime = 400,
      this.startIndex = 0,
      this.color = const Color(0xFFe34288),
      this.navigationPadding = 30});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex;
  double _selectorWidth = 99;

  AnimationController _animationController;
  Tween<double> _positionTween;
  Animation<double> _positionAnimation;

  List<GlobalKey> _tabItemKeys = List();

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback(_afterLayout);
    super.initState();

    selectedBarIndex = widget.startIndex;

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
      _tabItemKeys.add(GlobalKey());
    }
  }

  _afterLayout(_) {
    _updateSelectorPillWidth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(0, -5),
              blurRadius: 15)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 0,
            bottom: 0,
            left: widget.navigationPadding.toDouble(),
            right: widget.navigationPadding.toDouble()),
        child: Stack(
          children: <Widget>[
            IgnorePointer(
              child: Align(
                alignment: Alignment(_positionAnimation.value, 0),
                child: AnimatedContainer(
                  height: widget.selectorPillHeight,
                  width: _selectorWidth,
                  duration: Duration(
                      milliseconds: (widget.animationTime / 3).round()),
                  curve: Curves.easeOutExpo,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                            color: widget.color.withOpacity(0.6),
                            blurRadius: 15)
                      ]),
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
              _initAnimationAndStart(_positionAnimation.value, -1 + (i / (widget.barItems.length - 1)) * 2);
              _updateSelectorPillWidth();
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedContainer(
                width: widget.selectorPillPadding * 2 + 25.0,
//                width:  (MediaQuery.of(context).size.width -
//                            (_selectorWidth + widget.navigationPadding * 4)) /
//                        (widget.barItems.length),
                //to completely fill, set to (widget.barItems.length - 1), but that causes fractional overflow
                height: widget.height,
                decoration:
                    BoxDecoration(color: Colors.cyanAccent.withOpacity(0.0)), //tapable area (also use for debugging)
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: widget.animationTime),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widget.selectorPillPadding.toDouble(),
                    right: widget.selectorPillPadding.toDouble()),
                child: Row(
                  key: _tabItemKeys[i],
                  children: <Widget>[
                    Icon(item.iconData,
                        color: isSelected ? Colors.white : widget.color),
                    AnimatedSize(
                      duration: Duration(milliseconds: widget.animationTime),
                      curve: Curves.easeOutExpo,
                      vsync: this,
                      child: Text(
                        isSelected ? "  " + item.text : "",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return _barItems;
  }

  _updateSelectorPillWidth() {
    final RenderBox _renderBoxTab =
        _tabItemKeys[selectedBarIndex].currentContext.findRenderObject();
    _selectorWidth = _renderBoxTab.size.width + widget.selectorPillPadding * 2;
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
