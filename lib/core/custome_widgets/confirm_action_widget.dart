import 'package:flutter/material.dart';

import '../colors.dart';

class ConfirmActionWidget {
  Future<void> confirmAction(
      BuildContext context,
      {String? title, String? subTitle, String? actionText,required void Function() action}
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: Text(
            title??'Delete all folders?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          content: Text(
            subTitle??'All folders will be permanently deleted.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: primary,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: Text(
                actionText??'Delete',
                style: TextStyle(
                  color: red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      action();
    }
  }
}