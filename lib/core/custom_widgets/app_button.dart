import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
class AppButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final void Function()? onTap;
  final bool isLoading;
  AppButton({super.key,this.text,this.color,this.onTap,required  this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 25.w),
      child: GestureDetector(
        onTap: onTap??(){},
        child: Container(
          alignment: AlignmentGeometry.center,
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r),color: color),
          child: isLoading?Padding(
            padding:  EdgeInsets.all(3.r),
            child: CircularProgressIndicator(color: AppColors.lightBlue,),
          ):Text(text??'',style: AppTextStyles.button(color: Colors.white,)),

        ),
      ),
    );
  }
}
