//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/screens/chat/media_options/open_setting.dart';
import 'package:plug/utils/permissions.dart';
import 'package:plug/widgets/widgets_show.dart';
import 'package:mime/mime.dart';

class MultiDocumentPicker extends StatefulWidget {
  MultiDocumentPicker(
      {Key? key,
      required this.title,
      required this.callback,
      this.writeMessage,
      this.profile = false})
      : super(key: key);

  final String title;
  final Function callback;
  final bool profile;
  final Future<void> Function(String url, int timestamp)? writeMessage;

  @override
  _MultiDocumentPickerState createState() => new _MultiDocumentPickerState();
}

class _MultiDocumentPickerState extends State<MultiDocumentPicker> {
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  String? error;
  String mode = 'single';
  List<PlatformFile> seletedFiles = [];
  int currentUploadingIndex = 0;
  int maxNoOfFilesInMultiSharing = 1;
  int maxFileSizeAllowedInMB = 100;

  @override
  void initState() {
    super.initState();
  }

  cases(String filename) {
    return lookupMimeType(filename)!.split('/')[1];
    /* if (lookupMimeType(filename) == "application/pdf")
      return "pdf";
    else if (lookupMimeType(filename) == "application/msword" ||
        lookupMimeType(filename) ==
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ||
        lookupMimeType(filename) == "application/ms-doc" ||
        lookupMimeType(filename) == "application/doc") {
      print( lookupMimeType(filename));
      return "msword";
    }
    else if (lookupMimeType(filename) == "application/mspowerpoint" ||
        lookupMimeType(filename) == "application/powerpoint" ||
        lookupMimeType(filename) == "application/vnd.ms-powerpoint" ||
        lookupMimeType(filename) ==
            "application/vnd.openxmlformats-officedocument.presentationml.presentation" ||
        lookupMimeType(filename) == "application/x-mspowerpoint")
      return "ppt";
    else if (lookupMimeType(filename) == "application/excel" ||
        lookupMimeType(filename) == "application/vnd.ms-excel" ||
        lookupMimeType(filename) == "application/x-excel" ||
        lookupMimeType(filename) == "application/x-msexcel" ||
        lookupMimeType(filename) ==
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      return "xls";
    else
      return "txt";*/
  }

  bool checkTotalNoOfFilesIfExceeded() {
    if (seletedFiles.length > maxNoOfFilesInMultiSharing) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfAnyFileSizeExceeded() {
    int index = seletedFiles.indexWhere((file) =>
        File(file.path!).lengthSync() / 1000000 > maxFileSizeAllowedInMB);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  }

  void captureMultiPageDoc(bool isAddOnly) async {
    error = null;

    try {
      FilePickerResult? files = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowCompression: true,
          allowedExtensions: [
            'pdf',
            'docx',
            'doc',
            'xls',
            'xslx',
            'ppt',
            'pptx'
          ]);

      if (files != null) {
        if (files.files.length > 1) {
          seletedFiles = files.files;
          mode = 'multi';
          error = null;
          setState(() {});
        } else if (files.files.length == 1) {
          if (File(files.files[0].path!).lengthSync() / 1000000 >
              maxFileSizeAllowedInMB) {
            error =
                'File should be less than - ${maxFileSizeAllowedInMB}MB\n\nSelected File size is - ${(File(files.files[0].path!).lengthSync() / 1000000).round()}MB';

            setState(() {
              mode = "single";
            });
          } else {
            setState(() {
              mode = "single";
              seletedFiles = files.files;
            });
          }
        }
      }
    } catch (e) {
      ShowWidgets.toast('Cannot Send this Document type');
      Navigator.of(this.context).pop();
    }
  }

  Widget _buildSingleFile({File? file}) {
    if (file != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: Colors.yellow[900],
            size: 74,
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              basename(seletedFiles[0].path!).toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          )
        ],
      );
    } else {
      return new Text("Select file",
          style: new TextStyle(
            fontSize: 18.0.sp,
            color: Colors.black,
          ));
    }
  }

  Widget _buildMultiDocLoading() {
    return Container(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${currentUploadingIndex + 1}/${seletedFiles.length}',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: AppColors.activeIconColour),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Sending ..",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
                color: Colors.black),
          )
        ],
      )),
      color: Colors.white,
    );
  }

  Widget _buildMultiDoc() {
    if (seletedFiles.length > 0) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7),
          itemCount: seletedFiles.length,
          itemBuilder: (BuildContext context, i) {
            return Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.width / 2) - 20,
                    width: (MediaQuery.of(context).size.width / 2) - 20,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.yellow[900],
                          size: 44,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            basename(seletedFiles[i].path!).toString(),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  File(seletedFiles[i].path!).lengthSync() / 1000000 >
                          maxFileSizeAllowedInMB
                      ? Container(
                          height: (MediaQuery.of(context).size.width / 2) - 20,
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          color: Colors.white70,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsetsDirectional.all(10),
                              child: Text(
                                'File should be less than - ${maxFileSizeAllowedInMB}MB\nSelected File size is - ${(File(seletedFiles[i].path!).lengthSync() / 1000000).round()}MB',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Positioned(
                    right: 7,
                    top: 7,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          seletedFiles.removeAt(i);
                          if (seletedFiles.length <= 1) {
                            mode = "single";
                          }
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: new Icon(
                          Icons.close,
                          color: AppColors.activeIconColour,
                          size: 17,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // decoration: BoxDecoration(
              //     color: Colors.amber, borderRadius: BorderRadius.circular(15)),
            );
          });
    } else {
      return new Text("Select file",
          style: new TextStyle(
            fontSize: 18.0.sp,
            color: Colors.black,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // if (!isLoading) {
              Navigator.of(context).pop();
              // }
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: AppColors.activeIconColour,
            ),
          ),
          title: new Text(
            seletedFiles.length > 0
                ? '${seletedFiles.length} selected'
                : widget.title,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          actions: seletedFiles.length != 0 && !isLoading
              ? <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: AppColors.activeIconColour,
                      ),
                      onPressed: checkTotalNoOfFilesIfExceeded() == false
                          ? (checkIfAnyFileSizeExceeded() == false
                              ? () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  uploadEach(0);
                                }
                              : () {
                                  ShowWidgets.toast(
                                      "One or more file size exceeded the allowed maximum Size "
                                      ': ${maxFileSizeAllowedInMB}MB');
                                })
                          : () {
                              ShowWidgets.toast(
                                  "Maximum number of files can be selected :  " +
                                      maxNoOfFilesInMultiSharing.toString());
                            }),
                  SizedBox(
                    width: 8.0,
                  )
                ]
              : []),
      body: Stack(children: [
        new Column(children: [
          mode == 'single'
              ? new Expanded(
                  child: new Center(
                      child: error != null
                          ? ShowWidgets.fileSizeErrorWidget(error!)
                          : _buildSingleFile(
                              file: seletedFiles.length > 0
                                  ? File(seletedFiles[0].path!)
                                  : null)))
              : new Expanded(child: new Center(child: _buildMultiDoc())),
          _buildButtons()
        ]),
        Positioned(
          child: isLoading
              ? mode == "multi" && seletedFiles.length > 1
                  ? _buildMultiDocLoading()
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.activeIconColour)),
                      ),
                    )
              : Container(),
        )
      ]),
    );
  }

  uploadEach(int index) async {
    if (index > seletedFiles.length) {
      Navigator.of(this.context).pop();
    } else {
      int messagetime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        currentUploadingIndex = index;
      });

      List<String> files = [];
      for (PlatformFile i in seletedFiles) {
        files.add(i.path!);
      }
      print(cases(files[0]));

      await widget
          .callback("application", cases(files[0]),
              files /*File(seletedFiles[index].path!),
              timestamp: messagetime, totalFiles: seletedFiles.length*/
              )
          .then((value) {
        //if (seletedFiles.last == seletedFiles[index]) {
        Navigator.of(this.context).pop();
        /*} else {
            uploadEach(currentUploadingIndex + 1);
          }*/
      });
    }
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(
                  new Key('multi'),
                  Icons.add,
                  checkTotalNoOfFilesIfExceeded() == false
                      ? () {
                          PermissionsUtil.checkAndRequestPermission(
                                  Permission.photos)
                              .then((res) {
                            if (res == true) {
                              captureMultiPageDoc(false);
                            } else if (res == false) {
                              Navigator.pushReplacement(
                                  this.context,
                                  new MaterialPageRoute(
                                      builder: (context) => OpenSettings()));
                            } else {}
                          });
                        }
                      : () {
                          ShowWidgets.toast(
                              'Maximum number of files can be selected: ${maxNoOfFilesInMultiSharing}');
                        }),
            ]));
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color: AppColors.activeIconColour,
          textColor: Colors.white,
          onPressed: onPressed as void Function()?),
    );
  }
}
