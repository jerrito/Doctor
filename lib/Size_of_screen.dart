import 'package:flutter/widgets.dart';
class SizeConfig {
  static late  MediaQueryData  _mediaQueryData;
  static late double W;
  static late double H;
  static late double SH;
  static late double SV;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    W = _mediaQueryData.size.width;
    H = _mediaQueryData.size.height;
    SH = W/100;
    SV = H/100;

    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (W - _safeAreaHorizontal)/100;
    safeBlockVertical = (H - _safeAreaVertical)/100;
  }
}