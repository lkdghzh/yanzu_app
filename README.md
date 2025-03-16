# 研租 App

一个基于 Flutter 开发的租房应用。

## WebView Bridge API 文档

WebView Bridge 提供了一系列原生功能供 H5 页面调用。所有的异步方法都返回 Promise 对象，支持 async/await 语法。

### 1. 音频播放 (Audio)

```javascript
// 播放音频
yanzu.audio.play('https://example.com/audio.mp3')
  .then(() => console.log('开始播放'));

// 暂停播放
yanzu.audio.pause();

// 停止播放
yanzu.audio.stop();
```

### 2. 分享功能 (Share)

```javascript
yanzu.share({
  title: '分享标题',
  text: '分享内容'
});
```

### 3. 导航功能 (Navigation)

```javascript
// 打开地图
yanzu.navigation.openMap(31.2304, 121.4737, '上海东方明珠');

// 返回上一页
yanzu.navigation.back();
```

### 4. 图片处理 (Image)

```javascript
// 从相册选择图片
yanzu.image.pickFromGallery({
  maxWidth: 800,    // 可选
  maxHeight: 600,   // 可选
  imageQuality: 80  // 可选，0-100
}).then(result => {
  console.log('选择的图片:', result.path);
});

// 拍照
yanzu.image.takePhoto({
  maxWidth: 800,
  maxHeight: 600,
  imageQuality: 80
}).then(result => {
  console.log('拍摄的照片:', result.path);
});
```

### 5. 本地存储 (Storage)

```javascript
// 存储数据
yanzu.storage.set('userInfo', { id: 1, name: 'John' })
  .then(() => console.log('保存成功'));

// 获取数据
yanzu.storage.get('userInfo')
  .then(value => console.log('用户信息:', value));

// 删除数据
yanzu.storage.remove('userInfo');
```

### 6. 支付功能 (Payment)

```javascript
yanzu.payment.pay({
  amount: 100,
  orderId: 'ORDER_123',
  description: '房租支付'
}).then(result => {
  if (result.status === 'success') {
    console.log('支付成功');
  }
});
```

### 7. 设备信息 (Device)

```javascript
// 获取设备信息
yanzu.device.getInfo().then(info => {
  console.log('设备信息:', info);
  // 返回信息包含：
  // - appName: 应用名称
  // - packageName: 包名
  // - version: 版本号
  // - buildNumber: 构建号
  // - platform: 平台（ios/android）
  // - brand: 品牌（仅 Android）
  // - model: 型号
  // - systemVersion: 系统版本
});

// 触发震动
yanzu.device.vibrate();
```

### 8. 剪贴板 (Clipboard)

```javascript
// 复制文本
yanzu.clipboard.copy('要复制的文本');

// 粘贴文本
yanzu.clipboard.paste().then(text => {
  console.log('粘贴的内容:', text);
});
```

### 使用示例

```javascript
// 异步操作示例
async function handleImageUpload() {
  try {
    // 选择图片
    const image = await yanzu.image.pickFromGallery({
      maxWidth: 800,
      imageQuality: 80
    });
    
    // 获取用户信息
    const userInfo = await yanzu.storage.get('userInfo');
    
    // 分享图片
    yanzu.share({
      title: '分享图片',
      text: `来自${userInfo.name}的分享`,
      url: image.url
    });
  } catch (error) {
    console.error('操作失败:', error);
  }
}

// 设备信息和支付示例
async function handlePayment() {
  try {
    // 获取设备信息
    const deviceInfo = await yanzu.device.getInfo();
    
    // 发起支付
    const payResult = await yanzu.payment.pay({
      amount: 100,
      orderId: 'ORDER_123',
      device: deviceInfo.model
    });
    
    if (payResult.status === 'success') {
      // 支付成功，保存订单信息
      await yanzu.storage.set('lastPayment', {
        time: new Date().toISOString(),
        amount: 100
      });
      
      // 触发震动反馈
      yanzu.device.vibrate();
    }
  } catch (error) {
    console.error('支付失败:', error);
  }
}
```

### 注意事项

1. 所有返回 Promise 的方法都可能抛出异常，建议使用 try-catch 处理。

2. 图片处理相关功能需要相应的权限：
   - Android: 在 AndroidManifest.xml 中添加相机权限
   - iOS: 在 Info.plist 中添加相机和相册权限描述

3. 支付功能需要根据实际使用的支付平台（支付宝、微信支付等）进行配置。

4. 设备信息获取可能因系统限制返回部分信息。

5. 存储的数据会随应用卸载而清除。

## 开发环境

- Flutter: 3.x
- Dart: 3.x
- Android Studio / VS Code

## 依赖说明

主要使用的第三方包：

- webview_flutter: WebView 功能
- audioplayers: 音频播放
- image_picker: 图片选择/相机
- shared_preferences: 本地存储
- device_info_plus: 设备信息
- package_info_plus: 应用信息
- url_launcher: URL 处理
- share_plus: 系统分享

## ios
```
flutter run -d "iPhone 16" --pid-file=/tmp/flutter.pid
```
## 参考
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [online documentation](https://docs.flutter.dev/)

