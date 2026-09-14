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
      title: const Text('Delete activity?'),
      content: Text(
        'This will permanently remove "$itemLabel". This can\'t be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
