import 'package:flutter/material.dart';

class ProductPickerErrorState extends StatelessWidget {
  final String message;

  const ProductPickerErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
