import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/app/values/colors.dart';

hidekeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

class DialogOptionsAndroid extends StatelessWidget {
  const DialogOptionsAndroid({
    Key? key,
    required this.send_camera_image,
    required this.send_document,
    required this.send_gallery_images,
  }) : super(key: key);
  final Function send_camera_image;
  final Function send_gallery_images;
  final Function send_document;

  @override
  Widget build(BuildContext context) {
    Widget row_item(String name, String icon, Function func) => SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RawMaterialButton(
                disabledElevation: 0,
                onPressed: () {
                  hidekeyboard(context);
                  Navigator.of(context).pop();
                  func(/*"image","png"*/);
                },
                elevation: .5,
                fillColor: AppColors.chatColour,
                child: SvgPicture.asset(
                  icon,
                  width: 26.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              )
            ],
          ),
        );

    Widget row_options = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row_item("Document", "assets/images/Document.svg", send_document),
    //    row_item("Camera", "assets/images/Camera.svg", send_camera_image),
        row_item("Gellery", "assets/images/photo.svg", send_gallery_images),
      ],
    );
    return row_options;
  }
}
