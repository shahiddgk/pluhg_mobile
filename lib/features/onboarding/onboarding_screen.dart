import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/navigator/app_route.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/widgets/pluhg_button.dart';
import 'package:pluhg/features/onboarding/bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List details = [
      {
        "title": 'You Can Connect Two\nPeople You Know',
        "subtitle": '(But don\'t know each other)',
        "image": AppAsset.ONBOARDING_PAGE_ONE,
      },
      {
        "title": 'Without Sharing Their\nContact Details.',
        "subtitle": '(Connecting by a text reveals\ntheir numbers)',
        "image": AppAsset.ONBOARDING_PAGE_TWO,
      },
      {
        "title": 'They Decide If They\nAccept Or Decline\nYour Recommendation',
        "subtitle": '',
        "image": AppAsset.ONBOARDING_PAGE_THREE,
      },
      {
        "title": 'They Connect And Communicate\nIn Pluhg.',
        "subtitle": '(You are not in the middle)',
        "image": AppAsset.ONBOARDING_PAGE_FOUR,
      },
    ];
    final OnboardingBloc _bloc = OnboardingBloc();
    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            int currentPage = state.currentPage;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.pluhgColour,
                  width: double.infinity,
                  height: 568.13.h,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.19,
                                  color: AppColors.pluhgGreyColour,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32.87.h,
                          ),
                          Text(
                            details[currentPage]['title'],
                            style: TextStyle(
                                color: AppColors.pluhgGrey2Colour,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.4),
                          ),
                          SizedBox(
                            height: 11.46.h,
                          ),
                          Text(
                            details[currentPage]['subtitle'],
                            style: TextStyle(
                                color: AppColors.pluhgGrey2Colour,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.56),
                          ),
                          SizedBox(
                            width: 263.42.w,
                            height: 274.h,
                            child: SvgPicture.asset(
                              details[currentPage]['image'],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List<Widget>.generate(
                            4, (index) => _indicator(index == currentPage)),
                      ),
                      SizedBox(
                        height: 80.47.h,
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: currentPage > 0,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 115.w),
                              child: PluhgButton(
                                text: 'Previous',
                                borderWidth: 2,
                                borderColor: AppColors.pluhgGrayColour,
                                textColor: AppColors.pluhgGrayColour,
                                color: Colors.transparent,
                                onPressed: () {
                                  _bloc.add(PreviousEvent());
                                },
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 115.w),
                            child: PluhgButton(
                              text: currentPage == 3 ? 'Sign Up' : 'Next',
                              onPressed: () {
                                if (currentPage == 3) {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.AUTH_SCREEN);
                                } else {
                                  _bloc.add(NextEvent());
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _indicator(bool isCurrent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: isCurrent ? 25.44.w : 7.79.w,
      height: 7.79.h,
      margin: EdgeInsets.only(right: 5.46.w),
      decoration: BoxDecoration(
        color: AppColors.pluhgColour,
        borderRadius: BorderRadius.circular(50.r),
      ),
    );
  }
}
