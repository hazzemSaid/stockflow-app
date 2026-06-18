import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  // Spacing & Margins
  // Getters ensure ScreenUtil extensions are evaluated after initialization,
  // not lazily cached at first access (which could happen before ScreenUtilInit runs).
  static double get spacingTiny => 4.h;
  static double get spacingSmall => 8.h;
  static double get spacingMedium => 16.h;
  static double get spacingLarge => 24.h;
  static double get spacingXLarge => 32.h;
  static double get spacingXXLarge => 48.h;

  // Font Sizes
  static double get fontSmall => 10.sp;
  static double get fontMedium => 12.sp;
  static double get fontLarge => 14.sp;
  static double get fontXLarge => 16.sp;
  static double get fontXXLarge => 20.sp;
  static double get fontXXXLarge => 30.sp;

  // Icon Sizes
  static double get iconSmall => 16.w;
  static double get iconMedium => 24.w;
  static double get iconLarge => 32.w;
  static double get iconXLarge => 40.w;

  // Border Radius
  static double get radiusSmall => 8.r;
  static double get radiusMedium => 14.r;
  static double get radiusLarge => 16.r;
  static double get radiusXLarge => 24.r;
  static double get radiusXXLarge => 36.r;

  // Specific Dimensions
  static double get splashCircleDecorationOffset => 80.w;
  static double get splashCircleDecorationSmall => 240.w;
  static double get splashCircleDecorationLarge => 288.w;
  static double get splashLogoBoxOuter => 112.w;
  static double get splashLogoBoxInner => 80.w;
  static double get loginIconBoxSize => 64.w;
  static double get buttonHeight => 48.h;

  // Specific values
  static const double strokeWidthThin = 0.83;
  static double get strokeWidthMedium => 2.w;
}
