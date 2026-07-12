import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:makhzanflow/core/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/theme.dart';
import 'config/routes/router.dart';
import 'core/company/company_cubit.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: '.env');
  // Initialize Supabase
  await Supabase.initialize(
    url: MakhzanFlowEnv.supabaseUrl,
    anonKey: MakhzanFlowEnv.supabaseAnonKey,
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
            BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
            BlocProvider<CompanyCubit>.value(value: sl<CompanyCubit>()),
          ],
          child: child!,
        );
      },
      child: MaterialApp.router(
        title: 'MakhzanFlow',
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
  }
}
