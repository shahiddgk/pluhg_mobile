import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/widgets/notif_icon.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool backButton;
  bool notificationButton;
  final VoidCallback? onPressed;

  SimpleAppBar(
      {this.backButton = false,
      this.notificationButton = true,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      // leadingWidth: backButton ? 30 : 0,
      leading: backButton
          ? IconButton(
              onPressed:
                  onPressed != null ? onPressed : () => Navigator.pop(context),
              icon: SvgPicture.asset(
                "assets/images/back.svg",
                color: Colors.black,
              ),
            )
          : Container(),
      actions: [notificationButton ? NotifIcon() : Container()],
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
