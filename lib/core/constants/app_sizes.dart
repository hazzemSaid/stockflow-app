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
  static double get fontML => 13.sp;
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

  // Create business screen
  static double get logoPickerSize => 96.w;
  static double get backButtonSize => 36.w;
  static double get fieldIconSize => 14.w;
  static double get fieldHeight => 45.6.h;
  static double get buttonBottomHeight => 49.6.h;
  static double get chipHeight => 24.6.h;
  static double get chipFontSize => 10.sp;
  static double get formFieldTopPadding => 20.h;

  // Welcome / Decorative circles
  static double get circleDecorationLarge => 112.w;
  static double get circleDecorationMedium => 80.w;
  static double get circleDecorationSmall => 40.w;
  static double get logoIconSize => 36.w;
  static double get logoContainerSize => 80.w;
  static double get buttonMinHeight => 52.h;
  static double get welcomeLineHeight => 1.38;
  static double get welcomeSubtitleLineHeight => 1.62;
  static double get welcomeLetterSpacing => 0.5;

  // Icon stroke
  static const double strokeWidthThin = 0.83;
  static const double strokeWidthLogo = 3.0;
  static const double strokeWidthIcon = 2.5;
  static const double borderWidthThin = 0.8;
  static double get strokeWidthMedium => 2.w;
}
