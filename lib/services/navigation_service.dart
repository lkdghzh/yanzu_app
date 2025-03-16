import 'package:flutter/material.dart';
import '../utils/route_handler.dart';
//  // 打开 WebView
//  NavigationService.navigateTo('yanzu://webview?url=https://example.com&title=标题');

//  // 打开房源详情
//  NavigationService.navigateTo('yanzu://house?id=123');

//  // 打开搜索页面
//  NavigationService.navigateTo('yanzu://search?keyword=关键词');
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String url) async {
    try {
      final uri = Uri.parse(url);
      final widget = RouteHandler.handleUri(uri);

      if (widget != null) {
        return navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => widget),
        );
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
    return null;
  }

  static void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }
}
