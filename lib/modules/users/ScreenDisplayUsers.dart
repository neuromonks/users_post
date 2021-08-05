import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:users_post/helper/HelperFunction.dart';
import 'package:users_post/modules/users/ScreenDisplayPosts.dart';
import 'package:users_post/services/ServiceApi.dart';
import 'package:users_post/theme/ThemeColor.dart';
import 'package:users_post/theme/ThemeProgressIndicator.dart';
import 'package:users_post/widgets/WidgetError.dart';
import 'package:users_post/widgets/WidgetHomeBaseDesign.dart';
import 'package:users_post/widgets/WidgetNoDataFound.dart';

class ScreenDisplayUsers extends StatefulWidget {
  @override
  _ScreenDisplayUsersState createState() => _ScreenDisplayUsersState();
}

class _ScreenDisplayUsersState extends State<ScreenDisplayUsers> {
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
    return WidgetHomeBaseDesign(
        widgetBody: Container(
          margin: EdgeInsets.only(top: 10),
          child: RefreshIndicator(
            child: PagedGridView(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2),
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
        ),
        widgetTop: Container(
            padding: EdgeInsets.only(left: 15, top: 30),
            child: Row(
              children: [
                Text('Welcome User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500)),
              ],
            )));
  }

  Widget widgetUsers(var userDetails) {
    String status = '${userDetails['status']}';
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: ScreenDisplayPosts(
                  userId: userDetails['id'],
                ),
                type: HelperFunction.pageTransitionType()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${userDetails['name']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ThemeColor.darkPink)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text('${userDetails['email']}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ThemeColor.darkBlue)),
              ),
              Text(status[0].toUpperCase() + status.substring(1),
                  style: TextStyle(
                      color: status == "inactive" ? Colors.red : Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  _pagination(int pageKey) async {
    try {
      await ServiceApi.api(
        "users?page=$pageKey",
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
