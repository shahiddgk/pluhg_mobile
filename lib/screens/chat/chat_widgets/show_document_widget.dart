import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_document/open_document.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/screens/chat/chat_widgets/document_viewer.dart';
import 'package:dio/dio.dart';
class DocumentWidget extends StatelessWidget {
  DocumentWidget(this.file, {Key? key}) : super(key: key);
  String file;


  Future<String> downloadFile(
      {required String filePath, required String url}) async {
    // CancelToken cancelToken = CancelToken();
    Dio dio = new Dio();

    await dio.download(
      url,
      filePath,
      onReceiveProgress: (count, total) {
        debugPrint('---Download----Rec: $count, Total: $total');

      },
    );

    return filePath;
  }

  Future<void> initPlatformState(url) async {
    String filePath;

   // final url =
       // "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_500_kB.pdf";

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final name = await OpenDocument.getNameFile(url: url);

    final path = await OpenDocument.getPathDocument(folderName: "example");
    filePath = "$path/$name";

    final isCheck = await OpenDocument.checkDocument(filePath: filePath);

    debugPrint("Exist: $isCheck");
    try {
      if (!isCheck) {
        filePath = await downloadFile(filePath: "$filePath", url: url);
      }

      print(filePath);
      await OpenDocument.openDocument(
        filePath: filePath,
      );

    } on PlatformException catch (e) {
      debugPrint("ERROR: message_${e.message} ---- detail_${e.details}");
      filePath = 'Failed to get platform version.';
    }


  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()  {
          initPlatformState(APICALLS.imageBaseUrl + file);

         /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contex) =>
                      DocumentViewer(APICALLS.imageBaseUrl + file)));*/
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
                  child: SvgPicture.asset("assets/images/document.svg",
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
