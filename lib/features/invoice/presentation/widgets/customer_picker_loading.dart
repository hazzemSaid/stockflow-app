import 'package:flutter/material.dart';

class CustomerPickerLoadingState extends StatelessWidget {
  const CustomerPickerLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
