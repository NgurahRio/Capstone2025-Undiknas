import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  
  static double text(BuildContext context, double size) {
    if (Responsive.isDesktop(context)) {
      return size;
    } else if (Responsive.isTablet(context)) {
      return size * 0.83;
    } else {
      return size * 0.8;
    }
  }
}