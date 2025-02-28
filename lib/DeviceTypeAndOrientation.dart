import 'package:flutter/material.dart';

enum DeviceType {
  phonePortrait,
  phoneLandscape,
  tabletPortrait,
  tabletLandscape
}

getDeviceTypeAndOrientation(BuildContext context) {
  final shortestSize = MediaQuery.sizeOf(context).shortestSide;
  final orientation = MediaQuery.of(context).orientation;

  if (shortestSize < 450) {
    return orientation == Orientation.portrait
        ? DeviceType.phonePortrait
        : DeviceType.phoneLandscape;
  }
  return orientation == Orientation.portrait
      ? DeviceType.tabletPortrait
      : DeviceType.tabletLandscape;
}
