
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FontUtils {
  static const String _oppoSansFontFamily = 'OPPOSans';
  static const String _systemFontFamily = '';

  static Future<bool> getUseOppoSans() async {
    final box = await Hive.openBox('settings');
    return box.get('useOppoSans', defaultValue: false);
  }

  static Future<void> setUseOppoSans(bool value) async {
    final box = await Hive.openBox('settings');
    await box.put('useOppoSans', value);
  }

  static String getCurrentFontFamily() {
    // 这里需要同步获取值，暂时返回系统字体，实际使用时需要结合状态管理
    return _systemFontFamily;
  }

  static TextStyle getTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: getCurrentFontFamily(),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData applyFontToTheme(ThemeData theme, bool useOppoSans) {
    return theme.copyWith(
      textTheme: theme.textTheme.apply(
        fontFamily: useOppoSans ? _oppoSansFontFamily : _systemFontFamily,
      ),
      primaryTextTheme: theme.primaryTextTheme.apply(
        fontFamily: useOppoSans ? _oppoSansFontFamily : _systemFontFamily,
      ),
    );
  }
}