import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme/stockflow_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: StockFlowTheme.light(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('StockFlow'),
          ),
        ),
      ),
    );
  }
}
