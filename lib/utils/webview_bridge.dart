import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WebViewBridge {
  final WebViewController controller;
  final BuildContext context;
  final AudioPlayer audioPlayer = AudioPlayer();
  final ImagePicker _imagePicker = ImagePicker();

  WebViewBridge({required this.controller, required this.context}) {
    _setupBridges();
  }

  void _setupBridges() {
    controller
      ..addJavaScriptChannel(
        'AudioBridge',
        onMessageReceived: _handleAudio,
      )
      ..addJavaScriptChannel(
        'ShareBridge',
        onMessageReceived: _handleShare,
      )
      ..addJavaScriptChannel(
        'NavigationBridge',
        onMessageReceived: _handleNavigation,
      )
      ..addJavaScriptChannel(
        'DeviceBridge',
        onMessageReceived: _handleDevice,
      )
      ..addJavaScriptChannel(
        'ImageBridge',
        onMessageReceived: _handleImage,
      )
      ..addJavaScriptChannel(
        'StorageBridge',
        onMessageReceived: _handleStorage,
      )
      ..addJavaScriptChannel(
        'PaymentBridge',
        onMessageReceived: _handlePayment,
      )
      ..addJavaScriptChannel(
        'ClipboardBridge',
        onMessageReceived: _handleClipboard,
      );

    _injectJavaScript();
  }

  void _injectJavaScript() {
    const jsCode = '''
      window.yanzu = {
        // 原有的音频、分享、导航功能保持不变
        audio: {
          play: function(url) {
            return new Promise((resolve, reject) => {
              AudioBridge.postMessage(JSON.stringify({
                action: 'play',
                url: url,
                callback: '_cb_' + Date.now()
              }));
            });
          },
          pause: function() {
            AudioBridge.postMessage(JSON.stringify({
              action: 'pause'
            }));
          },
          stop: function() {
            AudioBridge.postMessage(JSON.stringify({
              action: 'stop'
            }));
          }
        },
        
        share: function(options) {
          ShareBridge.postMessage(JSON.stringify(options));
        },
        
        navigation: {
          openMap: function(latitude, longitude, name) {
            NavigationBridge.postMessage(JSON.stringify({
              action: 'openMap',
              latitude: latitude,
              longitude: longitude,
              name: name
            }));
          },
          back: function() {
            NavigationBridge.postMessage(JSON.stringify({
              action: 'back'
            }));
          }
        },
        
        // 图片相关功能
        image: {
          // 从相册选择图片
          pickFromGallery: function(options = {}) {
            return new Promise((resolve, reject) => {
              ImageBridge.postMessage(JSON.stringify({
                action: 'pickFromGallery',
                maxWidth: options.maxWidth,
                maxHeight: options.maxHeight,
                imageQuality: options.imageQuality,
                callback: '_cb_' + Date.now()
              }));
            });
          },
          // 拍照
          takePhoto: function(options = {}) {
            return new Promise((resolve, reject) => {
              ImageBridge.postMessage(JSON.stringify({
                action: 'takePhoto',
                maxWidth: options.maxWidth,
                maxHeight: options.maxHeight,
                imageQuality: options.imageQuality,
                callback: '_cb_' + Date.now()
              }));
            });
          }
        },
        
        // 本地存储
        storage: {
          set: function(key, value) {
            return new Promise((resolve, reject) => {
              StorageBridge.postMessage(JSON.stringify({
                action: 'set',
                key: key,
                value: value,
                callback: '_cb_' + Date.now()
              }));
            });
          },
          get: function(key) {
            return new Promise((resolve, reject) => {
              StorageBridge.postMessage(JSON.stringify({
                action: 'get',
                key: key,
                callback: '_cb_' + Date.now()
              }));
            });
          },
          remove: function(key) {
            StorageBridge.postMessage(JSON.stringify({
              action: 'remove',
              key: key
            }));
          }
        },
        
        // 支付功能
        payment: {
          pay: function(options) {
            return new Promise((resolve, reject) => {
              PaymentBridge.postMessage(JSON.stringify({
                action: 'pay',
                ...options,
                callback: '_cb_' + Date.now()
              }));
            });
          }
        },
        
        // 设备信息
        device: {
          getInfo: function() {
            return new Promise((resolve, reject) => {
              DeviceBridge.postMessage(JSON.stringify({
                action: 'getInfo',
                callback: '_cb_' + Date.now()
              }));
            });
          },
          vibrate: function() {
            DeviceBridge.postMessage(JSON.stringify({
              action: 'vibrate'
            }));
          }
        },
        
        // 剪贴板
        clipboard: {
          copy: function(text) {
            ClipboardBridge.postMessage(JSON.stringify({
              action: 'copy',
              text: text
            }));
          },
          paste: function() {
            return new Promise((resolve, reject) => {
              ClipboardBridge.postMessage(JSON.stringify({
                action: 'paste',
                callback: '_cb_' + Date.now()
              }));
            });
          }
        }
      };
    ''';

    controller.runJavaScript(jsCode);
  }

  // 处理音频相关操作
  void _handleAudio(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);

    switch (data['action']) {
      case 'play':
        await audioPlayer.play(UrlSource(data['url']));
        break;
      case 'pause':
        await audioPlayer.pause();
        break;
      case 'stop':
        await audioPlayer.stop();
        break;
    }
  }

  // 处理分享功能
  void _handleShare(JavaScriptMessage message) {
    final data = jsonDecode(message.message);
    Share.share(
      data['text'] ?? '',
      subject: data['title'],
    );
  }

  // 处理导航相关操作
  void _handleNavigation(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);

    switch (data['action']) {
      case 'openMap':
        final url =
            'https://maps.google.com/maps?q=${data['latitude']},${data['longitude']}';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
        break;
      case 'back':
        Navigator.of(context).pop();
        break;
    }
  }

  // 处理图片相关操作
  void _handleImage(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);

    try {
      XFile? image;
      switch (data['action']) {
        case 'pickFromGallery':
          image = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: data['maxWidth']?.toDouble(),
            maxHeight: data['maxHeight']?.toDouble(),
            imageQuality: data['imageQuality'],
          );
          break;
        case 'takePhoto':
          image = await _imagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: data['maxWidth']?.toDouble(),
            maxHeight: data['maxHeight']?.toDouble(),
            imageQuality: data['imageQuality'],
          );
          break;
      }

      if (image != null) {
        // 这里可以添加图片上传逻辑
        final result = {
          'path': image.path,
          'name': image.name,
          // 'url': 上传后的URL
        };
        _sendCallback(data['callback'], result);
      }
    } catch (e) {
      _sendError(data['callback'], e.toString());
    }
  }

  // 处理本地存储
  void _handleStorage(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);
    final prefs = await SharedPreferences.getInstance();

    try {
      switch (data['action']) {
        case 'set':
          await prefs.setString(data['key'], jsonEncode(data['value']));
          _sendCallback(data['callback'], true);
          break;
        case 'get':
          final value = prefs.getString(data['key']);
          _sendCallback(
              data['callback'], value != null ? jsonDecode(value) : null);
          break;
        case 'remove':
          await prefs.remove(data['key']);
          break;
      }
    } catch (e) {
      _sendError(data['callback'], e.toString());
    }
  }

  // 处理支付功能
  void _handlePayment(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);
    // TODO: 实现实际的支付逻辑
    _sendCallback(data['callback'], {'status': 'success'});
  }

  // 处理剪贴板
  void _handleClipboard(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);

    try {
      switch (data['action']) {
        case 'copy':
          await Clipboard.setData(ClipboardData(text: data['text']));
          break;
        case 'paste':
          final clipboardData = await Clipboard.getData('text/plain');
          _sendCallback(data['callback'], clipboardData?.text);
          break;
      }
    } catch (e) {
      _sendError(data['callback'], e.toString());
    }
  }

  // 处理设备信息
  void _handleDevice(JavaScriptMessage message) async {
    final data = jsonDecode(message.message);

    switch (data['action']) {
      case 'getInfo':
        try {
          final deviceInfo = DeviceInfoPlugin();
          final packageInfo = await PackageInfo.fromPlatform();

          Map<String, dynamic> info = {
            'appName': packageInfo.appName,
            'packageName': packageInfo.packageName,
            'version': packageInfo.version,
            'buildNumber': packageInfo.buildNumber,
          };

          if (Platform.isAndroid) {
            final androidInfo = await deviceInfo.androidInfo;
            info.addAll({
              'platform': 'android',
              'brand': androidInfo.brand,
              'model': androidInfo.model,
              'androidVersion': androidInfo.version.release,
              'sdkInt': androidInfo.version.sdkInt,
            });
          } else if (Platform.isIOS) {
            final iosInfo = await deviceInfo.iosInfo;
            info.addAll({
              'platform': 'ios',
              'name': iosInfo.name,
              'model': iosInfo.model,
              'systemVersion': iosInfo.systemVersion,
              'localizedModel': iosInfo.localizedModel,
            });
          }

          _sendCallback(data['callback'], info);
        } catch (e) {
          _sendError(data['callback'], e.toString());
        }
        break;
      case 'vibrate':
        HapticFeedback.mediumImpact();
        break;
    }
  }

  // 发送回调结果到 JavaScript
  void _sendCallback(String? callback, dynamic result) {
    if (callback != null) {
      final jsonResult = jsonEncode(result);
      controller
          .runJavaScript('window.$callback && window.$callback($jsonResult)');
    }
  }

  // 发送错误到 JavaScript
  void _sendError(String? callback, String error) {
    if (callback != null) {
      final jsonError = jsonEncode({'error': error});
      controller
          .runJavaScript('window.$callback && window.$callback($jsonError)');
    }
  }
}
