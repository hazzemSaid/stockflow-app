import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/widgets/app_network_image.dart';

class LogoPicker extends StatelessWidget {
  final String? imagePath;
  final String? logoUrl;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;
  final VoidCallback onClear;

  const LogoPicker({
    super.key,
    this.imagePath,
    this.logoUrl,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Container(
        width: AppSizes.logoPickerSize,
        height: AppSizes.logoPickerSize,
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: AppColors.primary,
              strokeWidth: 1.6,
              radiusValue: AppSizes.radiusLarge,
            ),
            child: imagePath != null
                ? _buildImageContent()
                : logoUrl != null
                    ? _buildNetworkContent()
                    : _buildPlaceholderContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return Stack(
      children: [
        Image.file(
          File(imagePath!),
          width: AppSizes.logoPickerSize,
          height: AppSizes.logoPickerSize,
          fit: BoxFit.cover,
        ),
        _buildClearButton(),
      ],
    );
  }

  Widget _buildNetworkContent() {
    return Stack(
      children: [
        AppNetworkImage(
          imageUrl: logoUrl!,
          width: AppSizes.logoPickerSize,
          height: AppSizes.logoPickerSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderContent(),
        ),
        _buildClearButton(),
      ],
    );
  }

  Widget _buildClearButton() {
    return Positioned(
      top: AppSizes.spacingTiny,
      right: AppSizes.spacingTiny,
      child: GestureDetector(
        onTap: onClear,
        child: Container(
          padding: EdgeInsets.all(AppSizes.spacingTiny),
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            size: AppSizes.iconSmall,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: AppSizes.iconMedium,
          color: AppColors.primary,
        ),
        SizedBox(height: AppSizes.spacingTiny),
        Text(
          AppStrings.logoPickerLabel,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(
                  AppStrings.pickFromGallery,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(
                  AppStrings.pickFromCamera,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radiusValue;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radiusValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const dashWidth = 6.0;
    const dashGap = 4.0;

    final path = Path()..addRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radiusValue),
    ));

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length).toDouble();
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radiusValue != radiusValue;
}
