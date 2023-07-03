import 'package:flutter/material.dart';
import 'package:phase_1_app/screens/auth_ui.dart';
import 'package:phase_1_app/screens/doctor_info.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:phase_1_app/utils/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              focusColor: Config.primaryColor,
              border: Config.OutlinedBorder,
              focusedBorder: Config.focusBorder,
              errorBorder: Config.errorBorder,
              enabledBorder: Config.OutlinedBorder,
              floatingLabelStyle: TextStyle(color: Config.primaryColor),
              prefixIconColor: Colors.black38),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          //this is initial route of the app
          //which is auth page (login and sign up)
          '/': (context) => const AuthPage(),
          //this is for main layout after login
          'main': (context) => const MainLayout(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == 'doc_details') {
            final String doctorName = settings.arguments as String;
            final String doctorImage = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => DoctorDetails(
                  doctorName: doctorName, doctorImage: doctorImage),
            );
          }
        });
  }
}

//now lets build login component
//and page view