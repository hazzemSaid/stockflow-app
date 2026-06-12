import 'package:flutter/material.dart';

class InvoiceDetailsLoadingState extends StatelessWidget {
  const InvoiceDetailsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
