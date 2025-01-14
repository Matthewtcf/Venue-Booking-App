import 'package:flutter/services.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/pages/Booking/booking.dart';
import 'package:venuebookingsystem/nav_page.dart';
import 'package:venuebookingsystem/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venuebookingsystem/pages/Settings/setting.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/pages/Settings/setting_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

String textfield = '';
String room_no = '0';
String userEmail = '';
String category = 'classroom';
String room_type = 'classroom';DateTime selectedDate = DateTime.now();

Future<void> main() async {
  SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: {
                '/home': (context) => nav_bar(),
                '/booking': (context) => Booking(),
                '/setting': (context) => Setting(),
                '/setting_display': (context) => Setting_display(),
              },
              home: const WidgetTree(),
              theme: ThemeData.from(
                useMaterial3: true,
                colorScheme: notifier.colorScheme,
              ));
        }));
  }
}

class ThemeNotifier with ChangeNotifier {
  int _themeIndex = 0;

  List<ColorScheme> _colorSchemes = [
    lightColorScheme,
    darkColorScheme,
    greenLightColorScheme,
    greenDarkColorScheme,
  ];

  ThemeNotifier() {
    // Load the saved theme index when the app starts up
    _loadThemeIndex();
  }

  int get themeIndex => _themeIndex;

  set themeIndex(int index) {
    _themeIndex = index;
    // Save the selected theme index to SharedPreferences
    _saveThemeIndex(index);
    notifyListeners();
  }

  ColorScheme get colorScheme => _colorSchemes[_themeIndex];

  Future<void> _saveThemeIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
  }

  Future<void> _loadThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('themeIndex') ?? 0;
    _themeIndex = savedIndex;
    notifyListeners();
  }
}
