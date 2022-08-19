import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/values/colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar(this.image, this.name, this.username, {Key? key}) : super(key: key);
  String image;
  String name;
  String username;

  @override
  Widget build(BuildContext context) {
    Widget avatar(String image, double radius) {
      if (image.isEmpty) {
        return SizedBox();
      }

      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage: CachedNetworkImageProvider(image),
        radius: radius,
      );
    }

    return AppBar(
      elevation: 0,
      // leadingWidth: backButton ? 30 : 0,
      leading: Container(
        margin: EdgeInsets.only(right: 0),
        width: 10,
        child: IconButton(
          icon: SvgPicture.asset(
            "assets/images/back.svg",
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: AppColors.pluhgWhite,
      // titleSpacing: -19,
      title: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            avatar(image, 22.r),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 3.h),
                SizedBox(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 19.0.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  username,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: AppColors.pluhgMenuGrayColour2, fontSize: 14.0.sp, fontWeight: FontWeight.w500),
                ),
                Container(height: 3.h),
              ],
            ),
          ],
        ),
      ),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 24.w, color: Colors.black))],
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
