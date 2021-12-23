import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emojipic;

class InputChatWidget extends StatefulWidget {
  const InputChatWidget(
      {Key? key, required this.send_function, required this.send_doc})
      : super(key: key);
  final Function send_function;
  final Function send_doc;

  @override
  _InputChatWidgetState createState() => _InputChatWidgetState();
}

class _InputChatWidgetState extends State<InputChatWidget> {
  FocusNode keyboardFocusNode = new FocusNode();
  final TextEditingController textEditingController =
      new TextEditingController();
  bool isemojiShowing = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  _onEmojiSelected(Emoji emoji) {
    textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  refreshInput() {
    setStateIfMounted(() {
      if (isemojiShowing == false) {
        keyboardFocusNode.unfocus();
        isemojiShowing = true;
      } else {
        isemojiShowing = false;
        keyboardFocusNode.requestFocus();
      }
    });
  }

  _onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    var _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    Widget input = Container(
      margin: EdgeInsets.only(bottom: Platform.isIOS == true ? 20 : 0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: 10.w,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.pluhgMenuGrayColour2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      onTap: () {
                        if (isemojiShowing == true) {
                        } else {
                          keyboardFocusNode.requestFocus();
                        }
                      },
                      showCursor: true,
                      focusNode: keyboardFocusNode,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontSize: 16.0.sp, color: pluhgMenuBlackColour),
                      controller: textEditingController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.5),
                        ),
                        hoverColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide:
                                BorderSide(color: AppColors.pluhgGreyColour)),
                        contentPadding: EdgeInsets.only(left: 16.w),
                        hintText: "Type here ..",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 8.w),
                      //  width: textEditingController.text.isNotEmpty ? 10 : 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          textEditingController.text.isNotEmpty
                              ? SizedBox()
                              : SizedBox(
                                  width: 30.w,
                                  child: IconButton(
                                    icon: new SvgPicture.asset(
                                      "assets/images/emoji.svg",
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      refreshInput();
                                    },
                                    color: AppColors.pluhgMilkColour,
                                  ),
                                ),
                        ],
                      ))
                ],
              ),
            ),
          ),

          Container(
            height: 44.w,
            width: 44.w,
            // alignment: Alignment.center,
            margin: EdgeInsets.only(left: 4.w, right: 4.w),
            decoration: BoxDecoration(
                color: AppColors.activeIconColour,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IconButton(
                    icon: new SvgPicture.asset(
                      "assets/images/join.svg",
                      color: AppColors.pluhgMilkColour,
                    ),
                    onPressed: () {
                      widget.send_doc();
                    })),
          ),
          // Button send message
          Container(
            height: 44.w,
            width: 44.w,
            // alignment: Alignment.center,
            margin: EdgeInsets.only(left: 4.w, right: 8.w),
            decoration: BoxDecoration(
                color: AppColors.activeIconColour,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IconButton(
                    icon: new SvgPicture.asset(
                      "assets/images/send.svg",
                      color: AppColors.pluhgMilkColour,
                    ),
                    onPressed: () {
                      if (textEditingController.text != "") {
                        widget.send_function(textEditingController.text);
                        textEditingController.clear();
                      }
                    })),
          ),
        ],
      ),
      width: double.infinity,
      height: 60.0,
      decoration: new BoxDecoration(
        // border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.transparent,
      ),
    );

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          input,
          isemojiShowing == true && _keyboardVisible == false
              ? Offstage(
                  offstage: !isemojiShowing,
                  child: SizedBox(
                    height: 300,
                    child: EmojiPicker(
                        onEmojiSelected:
                            (emojipic.Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 32.0,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: emojipic.Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: AppColors.activeIconColour,
                            iconColor: Colors.grey,
                            iconColorSelected: AppColors.pluhgGreyColour,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: AppColors.pluhgGreyColour,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: 'No Recents',
                            noRecentsStyle:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                )
              : SizedBox(),
        ]);
  }
}
