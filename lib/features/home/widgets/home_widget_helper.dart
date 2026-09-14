import 'package:home_widget/home_widget.dart';

class HomeWidgetHelper {
  static const String androidWidgetName = 'HomeScreenWidgetProvider';

  static Future<void> updateQuoteWidget({
    required String quote,
    required String author,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>('quote_text', quote);
      await HomeWidget.saveWidgetData<String>('quote_author', author);

      await HomeWidget.updateWidget(
        androidName: androidWidgetName,
      );
    } catch (e) {
      print('Error updating home widget: $e');
    }
  }
}