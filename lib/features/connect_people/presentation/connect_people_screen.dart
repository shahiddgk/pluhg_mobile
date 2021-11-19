import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/values/colors.dart';

class ConnectPeopleScreen extends StatelessWidget {
  const ConnectPeopleScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text('Pluhg'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 175.42.h),
            Text(
              'Connect Two\nPeople',
              style: TextStyle(
                fontSize: 35.sp,
                height: 1.14,
                fontWeight: FontWeight.w700,
                color: AppColors.activeLabelColour,
              ),
            ),
            SizedBox(height: 85.71.h),
            Row(
              children: [

              ],
            )
          ],
        ),
      ),
    );
  }
}