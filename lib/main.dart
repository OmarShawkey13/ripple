import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ripple/core/di/injections.dart';
import 'package:ripple/core/network/local/cache_helper.dart';
import 'package:ripple/core/network/service/notification_handler.dart';
import 'package:ripple/core/theme/theme.dart';
import 'package:ripple/core/utils/constants/my_bloc_observer.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.initialize("8ed8476b-ae5d-4ac6-8f0d-2298abd2018b");
  OneSignal.Notifications.requestPermission(true);
  NotificationHandler.initialize();
  Bloc.observer = MyBlocObserver();
  final bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  final bool isArabic = CacheHelper.getData(key: 'isArabicLang') ?? false;
  final String translation = await rootBundle.loadString(
    'assets/translations/${isArabic ? 'ar' : 'en'}.json',
  );
  runApp(
    MyApp(
      isDark: isDark,
      isArabic: isArabic,
      translation: translation,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final bool isArabic;
  final String translation;

  const MyApp({
    super.key,
    required this.isDark,
    required this.isArabic,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()
        ..initializeLanguage(
          isArabic: isArabic,
          translations: translation,
        )
        ..changeTheme(
          fromShared: isDark,
        ),
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            routes: Routes.routes,
            initialRoute: Routes.entry,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: HomeCubit.get(context).isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            builder: (context, child) {
              return Directionality(
                textDirection: HomeCubit.get(context).isArabicLang
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
