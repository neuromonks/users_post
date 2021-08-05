import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:users_post/helper/HelperFunction.dart';
import 'package:users_post/modules/users/ScreenDisplayPosts.dart';
import 'package:users_post/services/ServiceApi.dart';
import 'package:users_post/theme/ThemeProgressIndicator.dart';
import 'package:users_post/widgets/WidgetError.dart';
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
    return RefreshIndicator(
      child: PagedGridView(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.2),
        builderDelegate: PagedChildBuilderDelegate(
            firstPageProgressIndicatorBuilder: (context) =>
                Container(child: Center(child: ThemeProgressIndicator.spinKit)),
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
            noItemsFoundIndicatorBuilder: (context) => WidgetNoDataFound(),
            itemBuilder: (context, item, index) {
              return widgetUsers(item);
            }),
        pagingController: _pagingController,
      ),
      onRefresh: refreshPage,
    );
  }

  Widget widgetUsers(var userDetails) {
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
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: WidgetSpan(
                      child: Row(
                children: [
                  Text('Name : ',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  Expanded(
                    child: Text('${userDetails['name']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: RichText(
                    text: WidgetSpan(
                        child: Row(
                  children: [
                    Text('Email : ',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    Expanded(
                      child: Text('${userDetails['email']}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ))),
              ),
              RichText(
                  text: WidgetSpan(
                      child: Row(
                children: [
                  Text('Status : ',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  Text('${userDetails['status']}',
                      style: TextStyle(color: Colors.black)),
                ],
              ))),
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
