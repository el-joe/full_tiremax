import 'package:flutter/material.dart';

/// Border radius scale mirrored from the web app's Chakra UI radius scale.
class AppRadii {
  AppRadii._();

  static const double none = 0;
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xxl = 16;
  static const double xxxl = 24;
  static const double xxxxl = 32;
  static const double full = 9999;

  static BorderRadius radiusNone = BorderRadius.circular(none);
  static BorderRadius radiusXs = BorderRadius.circular(xs);
  static BorderRadius radiusSm = BorderRadius.circular(sm);
  static BorderRadius radiusMd = BorderRadius.circular(md);
  static BorderRadius radiusLg = BorderRadius.circular(lg);
  static BorderRadius radiusXl = BorderRadius.circular(xl);
  static BorderRadius radiusXxl = BorderRadius.circular(xxl);
  static BorderRadius radiusXxxl = BorderRadius.circular(xxxl);
  static BorderRadius radiusXxxxl = BorderRadius.circular(xxxxl);
  static BorderRadius radiusFull = BorderRadius.circular(full);
}
