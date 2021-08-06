import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:users_post/services/ServiceApi.dart';
import 'package:users_post/theme/ThemeColor.dart';
import 'package:users_post/theme/ThemeProgressIndicator.dart';
import 'package:users_post/widgets/WidgetAppBar.dart';
import 'package:users_post/widgets/WidgetError.dart';
import 'package:users_post/widgets/WidgetHomeBaseDesign.dart';
import 'package:users_post/widgets/WidgetNoDataFound.dart';

class ScreenDisplayComments extends StatefulWidget {
  final postId;
  ScreenDisplayComments({@required this.postId});
  @override
  _ScreenDisplayCommentsState createState() => _ScreenDisplayCommentsState();
}

class _ScreenDisplayCommentsState extends State<ScreenDisplayComments> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _pagination(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: WidgetHomeBaseDesign(
            widgetBody: SafeArea(
              child: RefreshIndicator(
                child: PagedListView(
                  padding: EdgeInsets.all(10),
                  builderDelegate: PagedChildBuilderDelegate(
                      firstPageProgressIndicatorBuilder: (context) => Container(
                          child: Center(child: ThemeProgressIndicator.spinKit)),
                      newPageProgressIndicatorBuilder: (context) => Container(
                            child: Center(
                              child: ThemeProgressIndicator.spinKit,
                            ),
                          ),
                      firstPageErrorIndicatorBuilder: (context) => Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2.7),
                          child: WidgetError()),
                      newPageErrorIndicatorBuilder: (context) =>
                          Container(child: Center(child: WidgetError())),
                      noItemsFoundIndicatorBuilder: (context) =>
                          WidgetNoDataFound(),
                      itemBuilder: (context, item, index) {
                        return widgetUsers(item, index);
                      }),
                  pagingController: _pagingController,
                ),
                onRefresh: refreshPage,
              ),
            ),
            widgetTop: Container(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 20,
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop()),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            )));
  }

  Widget widgetUsers(var commentDetails, int index) {
    String type = index % 2 == 0 ? 'r' : 'w';
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
      child: Align(
        alignment: (type == "r" ? Alignment.topLeft : Alignment.topRight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              type == 'r' ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: type == 'r'
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                color: (type == "r"
                    ? ThemeColor.lightestGrey
                    : ThemeColor.darkPink),
              ),
              padding: EdgeInsets.all(16),
              child: Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${commentDetails['body']}',
                      style: TextStyle(
                          height: 1.58,
                          fontWeight: FontWeight.w400,
                          color:
                              type == 'r' ? Color(0xFF3C3B3C) : Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pagination(int pageKey) async {
    try {
      await ServiceApi.api(
        "comments?page=$pageKey&post_id=${widget.postId}",
        "get",
        context,
      ).then((response) {
        List newItems = [];
        if (response != null) {
          newItems = response['data'];
          final isLastPage = newItems.length < 20;
          if (isLastPage) {
            _pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(newItems, nextPageKey);
          }
        } else {
          _pagingController.error = "error";
        }
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> refreshPage() async {
    _pagingController.refresh();
    return;
  }
}
