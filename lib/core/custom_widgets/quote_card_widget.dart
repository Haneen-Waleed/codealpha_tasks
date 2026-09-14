import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCardWidget extends StatelessWidget {
  final String quote;
  final String author;
  final bool fav;
  final void Function()? onPressedFav;
  final void Function()? onPressedNotFav;

  QuoteCardWidget({
    super.key,
    required this.quote,
    required this.author,
    required this.fav,
    this.onPressedFav,
    this.onPressedNotFav,
  });

  final GlobalKey _cardKey = GlobalKey();

  Future<void> _shareCardAsImage() async {
    try {
      final boundary =
      _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/quote_card.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Check out this quote!');
    } catch (e) {
      debugPrint('Error sharing card image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 25.w),
      child: Stack(
        children: [
          // 1. Only the card visual gets wrapped in RepaintBoundary
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.rotate(
                          angle: -math.pi,
                          child: const Icon(Icons.format_quote_rounded),
                        ),
                        // Empty space matching icon dimensions to maintain layout spacing
                         SizedBox(height: 48.h),
                      ],
                    ),
                     SizedBox(height: 25.h),
                    Text(quote, style: AppTextStyles.quote()),
                     SizedBox(height: 25.h),
                    Text(
                      '_$author',
                      style: AppTextStyles.quote(color: AppColors.grey),
                    ),
                     SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),

          // 2. Interactive action buttons overlaid outside RepaintBoundary
          Positioned(
            top: 0,
            right: 12.w,
            child: Row(
              children: [
                IconButton(
                  onPressed: _shareCardAsImage,
                  icon: Icon(
                    Icons.share,
                    color: AppColors.text,
                  ),
                ),
                fav
                    ? IconButton(
                  onPressed: onPressedFav,
                  icon: Icon(
                    Icons.favorite,
                    color: AppColors.text,
                  ),
                )
                    : IconButton(
                  onPressed: onPressedNotFav,
                  icon: Icon(
                    Icons.favorite_border,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}