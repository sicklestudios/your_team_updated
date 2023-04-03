import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/navigation_service.dart';
import 'package:yourteam/screens/auth/login_screen.dart';
import 'package:yourteam/screens/auth/splash_screen.dart';
import 'package:yourteam/screens/home_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yourteam/service/fcmcallservices/fcmcallservices.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await initializeService();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Your Team',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: mainMaterialColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textSelectionTheme: const TextSelectionThemeData(
          // cursorColor: Colors.red,
          // selectionColor: Colors.black,
          selectionHandleColor: Colors.black,
        ),
      ),
      onGenerateRoute: AppRoute.generateRoute,
      navigatorKey: NavigationService.instance.navigationKey,
      navigatorObservers: <NavigatorObserver>[
        NavigationService.instance.routeObserver
      ],
      initialRoute: '/',
      // home: DialScreen(),
      routes: {
        '/': (context) {
          return const SplashScreen();
        },
        '/home': ((context) {
          return const HomeController();
        }),
        '/login': ((context) {
          return const LoginScreen();
        })
      },
    );
  }
}
