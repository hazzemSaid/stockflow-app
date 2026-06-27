import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'config/theme/theme.dart';
import 'config/routes/router.dart';
import 'core/company/company_cubit.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await supabase.Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'mock-anon-key'),
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
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<AuthCubit>()),
            BlocProvider<CompanyCubit>.value(value: sl<CompanyCubit>()),
          ],
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
