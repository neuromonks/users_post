import 'package:flutter/material.dart';
import 'package:users_post/theme/ThemeColor.dart';

class WidgetHomeBaseDesign extends StatefulWidget {
  Widget widgetTop, widgetBody;
  EdgeInsetsGeometry marginToBody;
  String backgroundImage;
  Gradient gradient;
  WidgetHomeBaseDesign(
      {@required this.widgetBody,
      @required this.widgetTop,
      this.marginToBody,
      this.backgroundImage,
      this.gradient});
  @override
  _WidgetHomeBaseDesignState createState() => _WidgetHomeBaseDesignState();
}

class _WidgetHomeBaseDesignState extends State<WidgetHomeBaseDesign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          widget.backgroundImage != null
              ? Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 1.5),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: new DecorationImage(
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.dstATop),
                            image: new NetworkImage(
                              '${widget.backgroundImage}',
                            ),
                          ),
                        ),
                      ),
                      widget.widgetTop,
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 4),
                  decoration: BoxDecoration(
                      gradient: widget.gradient != null
                          ? widget.gradient
                          : LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                  ThemeColor.darkBlue,
                                  ThemeColor.darkPink,
                                  ThemeColor.pink,
                                ])),
                  child: widget.widgetTop,
                ),
          Container(
              margin: widget.marginToBody == null
                  ? EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5.5)
                  : widget.marginToBody,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white),
              child: widget.widgetBody)
        ],
      ),
    );
  }
}
