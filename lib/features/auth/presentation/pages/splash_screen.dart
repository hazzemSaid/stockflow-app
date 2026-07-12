import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:makhzanflow/features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.4, -0.6),
            radius: 1.5,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Stack(
          children: [
            // Orange decorative shapes (simplified)
            Positioned(
              left: -AppSizes.splashCircleDecorationOffset,
              top: -AppSizes.splashCircleDecorationOffset,
              child: Container(
                width: AppSizes.splashCircleDecorationSmall,
                height: AppSizes.splashCircleDecorationSmall,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: AppSizes.splashCircleDecorationOffset,
              top: AppSizes.splashCircleDecorationLarge * 1.5,
              child: Container(
                width: AppSizes.splashCircleDecorationLarge,
                height: AppSizes.splashCircleDecorationLarge,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                // Logo Placeholder
                Container(
                  width: AppSizes.splashLogoBoxOuter,
                  height: AppSizes.splashLogoBoxOuter,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                      width: AppSizes.strokeWidthThin,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                  ),
                  child: Center(
                    child: Container(
                      width: AppSizes.splashLogoBoxInner,
                      height: AppSizes.splashLogoBoxInner,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusLarge,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        height: 40,
                        width: 50,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.spacingLarge),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.white,
                    fontSize: AppSizes.fontXXXLarge,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.75,
                  ),
                ),
                SizedBox(height: AppSizes.spacingTiny),
                Text(
                  AppStrings.appNameArabic,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: AppSizes.fontXLarge,
                  ),
                ),
                SizedBox(height: AppSizes.spacingSmall),
                Text(
                  AppStrings.appSubtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.white.withValues(alpha: 0.6),
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
                const Spacer(flex: 2),
                // Loading Indicator
                SpinKitRing(
                  color: AppColors.white.withValues(alpha: 0.8),
                  size: AppSizes.iconMedium,
                  lineWidth: AppSizes.strokeWidthMedium,
                ),
                SizedBox(height: AppSizes.spacingMedium),
                Text(
                  AppStrings.loading,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.white.withValues(alpha: 0.6),
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
                const Spacer(),
                Text(
                  AppStrings.appVersion,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.white.withValues(alpha: 0.4),
                    fontSize: AppSizes.fontSmall,
                  ),
                ),
                SizedBox(height: AppSizes.spacingLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

