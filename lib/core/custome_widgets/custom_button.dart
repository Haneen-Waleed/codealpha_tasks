import 'package:flutter/material.dart';

import '../colors.dart';

class CustomButton extends StatelessWidget {
 final String? text;
 final void Function()? onPressed;
  const CustomButton({super.key,this.text,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed ??() {},
      child:  Text(
        text??'',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
