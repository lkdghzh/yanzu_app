import 'package:flutter/material.dart';
import '../screens/webview_screen.dart';

class RouteHandler {
  static const String SCHEME = 'yanzu';

  // 处理 URI 并返回对应的页面
  static Widget? handleUri(Uri uri) {
    if (uri.scheme != SCHEME) return null;

    switch (uri.host) {
      case 'webview':
        // yanzu://webview?url=https://example.com&title=标题
        final url = uri.queryParameters['url'];
        final title = uri.queryParameters['title'] ?? '网页';
        if (url != null) {
          return WebViewScreen(url: url, title: title);
        }
        break;

      case 'house':
        // yanzu://house?id=123
        final houseId = uri.queryParameters['id'];
        // TODO: 返回房源详情页
        break;

      case 'search':
        // yanzu://search?keyword=关键词
        final keyword = uri.queryParameters['keyword'];
        // TODO: 返回搜索结果页
        break;
    }
    return null;
  }

  // 生成 WebView 链接
  static String generateWebViewUrl({required String url, String? title}) {
    final params = {
      'url': url,
      if (title != null) 'title': title,
    };
    return Uri(
      scheme: SCHEME,
      host: 'webview',
      queryParameters: params,
    ).toString();
  }

  // 生成房源详情链接
  static String generateHouseDetailUrl(String houseId) {
    return Uri(
      scheme: SCHEME,
      host: 'house',
      queryParameters: {'id': houseId},
    ).toString();
  }

  // 生成搜索链接
  static String generateSearchUrl(String keyword) {
    return Uri(
      scheme: SCHEME,
      host: 'search',
      queryParameters: {'keyword': keyword},
    ).toString();
  }
}
