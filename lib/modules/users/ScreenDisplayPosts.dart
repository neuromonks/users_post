import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:users_post/helper/HelperFunction.dart';
import 'package:users_post/modules/users/ScreenDisplayComments.dart';
import 'package:users_post/services/ServiceApi.dart';
import 'package:users_post/theme/ThemeColor.dart';
import 'package:users_post/theme/ThemeProgressIndicator.dart';
import 'package:users_post/widgets/WidgetAppBar.dart';
import 'package:users_post/widgets/WidgetError.dart';
import 'package:users_post/widgets/WidgetNoDataFound.dart';

class ScreenDisplayPosts extends StatefulWidget {
  final userId;
  ScreenDisplayPosts({@required this.userId});
  @override
  _ScreenDisplayPostsState createState() => _ScreenDisplayPostsState();
}

class _ScreenDisplayPostsState extends State<ScreenDisplayPosts> {
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
        appBar: WidgetAppBar(title: 'Posts'),
        body: SafeArea(
          child: RefreshIndicator(
            child: PagedListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          vertical: MediaQuery.of(context).size.height / 2.7),
                      child: WidgetError()),
                  newPageErrorIndicatorBuilder: (context) =>
                      Container(child: Center(child: WidgetError())),
                  noItemsFoundIndicatorBuilder: (context) =>
                      WidgetNoDataFound(),
                  itemBuilder: (context, item, index) {
                    return widgetUsers(item);
                  }),
              pagingController: _pagingController,
            ),
            onRefresh: refreshPage,
          ),
        ));
  }

  Widget widgetUsers(var userDetails) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: ScreenDisplayComments(
                  postId: userDetails['id'],
                ),
                type: HelperFunction.pageTransitionType()));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 15),
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${userDetails['title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ThemeColor.darkPink, fontWeight: FontWeight.w700)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text('${userDetails['body']}',
                    style: TextStyle(color: ThemeColor.darkBlue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pagination(int pageKey) async {
    try {
      await ServiceApi.api(
        "posts?page=$pageKey&user_id=${widget.userId}",
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
