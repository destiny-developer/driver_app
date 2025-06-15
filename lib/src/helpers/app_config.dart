import 'package:deliveryboy/src/repository/settings_repository.dart' as settingRepo;
import 'package:flutter/material.dart';

class App {
  BuildContext? _context;
  double _height = 0.0;
  double _width = 0.0;
  double _heightPadding = 0.0;
  double _widthPadding = 0.0;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context!);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) => _height * v;

  double appWidth(double v) => _width * v;

  double appVerticalPadding(double v) => _heightPadding * v;

  double appHorizontalPadding(double v) => _widthPadding * v;
}

class Colors {
  Color mainColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.mainColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color secondColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.secondColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color accentColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.accentColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color mainDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.mainDarkColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color secondDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.secondDarkColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color accentDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.accentDarkColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }

  Color scaffoldColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.scaffoldColor!.replaceAll("#", "0xFF"))).withValues(alpha: opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withValues(alpha: opacity);
    }
  }
}
