import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  TextEditingController searchController = new TextEditingController();
  bool backButton;
  Function onChanged;
  SearchAppBar(this.searchController,this.onChanged, {this.backButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leadingWidth: backButton?30:0,
      leading: backButton?GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.grey,
          ),
        ),
      ):SizedBox.shrink(),
      title: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Color(0xffEBEBEB),
          borderRadius: BorderRadius.circular(39.r),
        ),
        child: TextFormField(
          controller: searchController,
          onChanged: (value) {
            onChanged(value);
          },
          decoration: InputDecoration(
              hintText: "Search Contact",
              prefixIcon: Icon(
                Icons.search_outlined,
                color: Color(0xff080F18),
              ),
              suffixIcon: Visibility(
                  visible: searchController.text.isNotEmpty,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      searchController.clear();
                    },
                  )),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(12.0),
              // labelText: "Bill",
              hintStyle: TextStyle(
                  fontSize: 14,
                  color: pluhgMenuBlackColour,
                  fontWeight: FontWeight.w300)),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contex) => NotificationScreenView()));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.notifications_outlined, color: Color(0xff080F18)),
          ),
        ),
      ],
    );
  }

  static final _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;
}
