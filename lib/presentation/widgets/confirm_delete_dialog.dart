import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Returns true if the user confirmed deletion, false/null otherwise.
Future<bool?> showConfirmDeleteDialog(
    BuildContext context, {
      required String itemLabel,
    }) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title:  Text(
        'Delete activity?',
        style: TextStyle(color: AppColors.white),
      ),
      content: Text(
        'This will permanently remove "$itemLabel". This can\'t be undone.',
        style:  TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}