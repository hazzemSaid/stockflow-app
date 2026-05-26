import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/theme.dart';
import 'config/routes/router.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://xeiosxvazvdwpdsxrrvi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlaW9zeHZhenZkd3Bkc3hycnZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3MTU0OTksImV4cCI6MjA5NTI5MTQ5OX0.HNEQ2af_ysY_AvroTSO5OY2D7THSDzj6dhZ-HCWWu7w',
  );

  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(320, 762),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: MaterialApp.router(
            title: 'StockFlow',
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ar', 'EG')],
            locale: const Locale('ar', 'EG'),

            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
