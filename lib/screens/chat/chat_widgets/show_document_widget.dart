import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/app/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/screens/chat/chat_widgets/document_viewer.dart';

class DocumentWidget extends StatelessWidget {
  DocumentWidget(this.file, {Key? key}) : super(key: key);
  String file;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contex) => DocumentViewer(
                      "https://pluhg.s3.us-east-2.amazonaws.com/" + file)));
        },
        child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.purpleIconColour,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(children: [
              Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.pluhgYellowColour,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SvgPicture.asset("assets/images/Document.svg",
                      color: AppColors.pluhgWhite)),
              Container(
                width: 8.w,
              ),
              Text(
                file.replaceAll("public/", "").split("_")[1],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              )
            ])));
  }
}
