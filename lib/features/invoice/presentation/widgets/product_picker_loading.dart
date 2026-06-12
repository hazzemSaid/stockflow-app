import 'package:flutter/material.dart';

class ProductPickerLoadingState extends StatelessWidget {
  const ProductPickerLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
