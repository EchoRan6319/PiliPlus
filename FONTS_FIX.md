# OPPO Sans 字体修复方案

## 问题描述
自Flutter 3.38版本起，在ColorOS设备上出现字体调用异常问题，系统字体被错误替换为ColorOS衬线字体OPPO Serif。

## 解决方案

### 1. 字体集成与配置
- 将OPPO Sans 4.0.ttf字体文件复制到 `assets/fonts/` 目录
- 在 `pubspec.yaml` 中添加字体配置
- 仅对Android平台进行修改，保持其他平台代码不变

### 2. 用户设置功能
- 在应用设置界面的"外观设置"中添加"使用OPPO Sans字体"的手动开关选项
- 实现开关状态的持久化存储
- 当用户开启该选项时，应用内所有文本元素均使用OPPO Sans字体

### 3. 上游更新兼容方案
- 使用独立的存储键 `useOppoSans`，避免与现有设置冲突
- 所有修改均为增量添加，不会影响上游代码
- 代码结构清晰，便于维护和更新

### 4. 实现细节

#### 4.1 字体配置
在 `pubspec.yaml` 中添加：
```yaml
fonts:
  - family: OPPOSans
    fonts:
      - asset: assets/fonts/OPPO Sans 4.0.ttf
```

#### 4.2 字体管理工具
创建 `lib/utils/font_utils.dart` 工具类，用于处理字体相关操作。

#### 4.3 设置选项
在 `lib/pages/setting/models/style_settings.dart` 中添加开关选项：
```dart
SwitchModel(
  title: '使用OPPO Sans字体',
  subtitle: '仅在ColorOS设备上有效，用于解决系统字体被错误替换为OPPO Serif的问题',
  leading: const Icon(Icons.font_download_outlined),
  setKey: 'useOppoSans',
  defaultVal: false,
  onChanged: (value) => Get.forceAppUpdate(),
),
```

#### 4.4 主题集成
在 `lib/utils/theme_utils.dart` 中修改 `getThemeData` 方法，添加字体支持：
```dart
final useOppoSans = Pref.useOppoSans;
final fontFamily = useOppoSans ? 'OPPOSans' : null;
```

### 5. 构建流程
1. 运行 `flutter pub get` 更新依赖
2. 运行 `flutter build apk` 构建APK

### 6. 测试建议
- 在搭载ColorOS的设备上测试字体替换效果
- 测试开关功能的切换效果及状态保存功能
- 模拟上游代码更新场景，验证合并后构建流程是否能自动应用字体修复
- 确保字体修改不会对应用性能产生负面影响

### 5. 弹幕字体修复

#### 5.1 问题描述
在视频播放中，弹幕的字体没有完全映射，即使开启了OPPO Sans字体选项，弹幕仍然使用系统默认字体。

#### 5.2 解决方案
修改 `canvas_danmaku` 库，添加字体支持：

1. **修改 DanmakuOption 类**
   - 添加 `fontFamily` 参数，用于指定弹幕字体

2. **更新渲染方法**
   - 修改 `DmUtils.generateParagraph` 方法，支持自定义字体
   - 修改 `DmUtils.recordDanmakuImage` 方法，支持自定义字体
   - 修改 `DmUtils.recordSpecialDanmakuImg` 方法，支持自定义字体

3. **更新 Painter 类**
   - 修改 `ScrollDanmakuPainter` 类，添加 `fontFamily` 参数
   - 修改 `StaticDanmakuPainter` 类，添加 `fontFamily` 参数
   - 修改 `SpecialDanmakuPainter` 类，添加 `fontFamily` 参数

4. **集成到应用**
   - 在 `danmaku_options.dart` 中，创建 `DanmakuOption` 时添加 `fontFamily` 参数
   - 根据用户设置的 `useOppoSans` 值，决定是否使用 OPPOSans 字体

### 6. 上游更新处理方案

#### 6.1 当前配置
- 项目使用本地修改后的 `canvas_danmaku` 库（通过 `path: canvas_danmaku` 引用）

#### 6.2 上游更新步骤
1. **拉取上游更新**
   - 进入 `canvas_danmaku` 目录
   - 运行 `git pull` 拉取最新代码

2. **合并修改**
   - 检查上游更新是否与我们的修改冲突
   - 如果有冲突，手动解决
   - 确保 `fontFamily` 相关的修改被保留

3. **验证构建**
   - 运行 `flutter pub get` 更新依赖
   - 运行 `flutter build apk` 构建APK
   - 测试应用是否正常运行，弹幕字体是否正确显示

#### 6.3 版本管理建议
- 在 `canvas_danmaku` 目录中使用 git 进行版本管理
- 创建一个分支来保存我们的修改，例如 `feature/font-family-support`
- 每次上游更新后，将我们的修改合并到最新代码中

## 总结
本方案通过集成OPPO Sans字体并提供用户开关选项，解决了ColorOS设备上的字体调用异常问题。同时，通过修改canvas_danmaku库，确保了弹幕字体也能正确映射。采用了独立的存储键和增量修改的方式，确保了与上游代码的兼容性。