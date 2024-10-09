// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyaltylinx/pages/auth/create_acc_number.dart';
import 'package:loyaltylinx/pages/auth/home_login.dart';
import 'package:loyaltylinx/pages/auth/link_card.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/auth/register.dart';
import 'package:loyaltylinx/pages/theme/dark_theme.dart';
import 'package:loyaltylinx/pages/theme/light_theme.dart';
import 'package:loyaltylinx/pages/veiws/home.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/profile/change_password.dart';
import 'package:loyaltylinx/pages/veiws/profile/settings.dart';
import 'package:loyaltylinx/pages/veiws/reward_transaction.dart';
import 'package:loyaltylinx/pages/veiws/rewards.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:loyaltylinx/pages/veiws/transaction_credit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

List? userData0;
Object? token;
String? tokenMain;

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: notifier,
        builder: (_, mode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const SplashScreen(),
            themeMode: mode,
            // home: const HomeView(),
            routes: {
              '/transactions_credit': (context) => const Transaction(),
              '/home': (context) => const HomePage(),
              '/rewards': (context) => const RewardsPage(),
              '/profile': (context) => const ProfilePage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterView(),
              '/bottomnavbar': (context) => BottomNavBarExample(
                    userData: userData0!,
                  ),
              '/homeView': (context) => const HomeView(),
              '/numberRegister': (context) => const NumberRegister(),
              '/linkCard': (context) => const LinkCard(),
              '/transactions_reward': (context) => const TransactionRewards(),
              '/settings': (context) => const Settings(),
              '/change_password': (context) => const NewPasswordForm(),
            },
          );
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getProfile(String token, objectToken, context) async {
    final response = await http.get(
      Uri.parse('https://loyalty-linxapi.vercel.app/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = json['userProfile'];
      if (userData != null) {
        userData0 = [userData];
        if (token.isEmpty) {
          print("empty");
        } else {
          tokenMain = token;
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavBarExample(
                      userData: [userData],
                    )),
            (route) => false);
      }
    } else {}
  }

  Future<void> getUserTokenMain() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('user_token');
    if (token != null) {
      final json = jsonDecode(token.toString());
      if (json != null) {
        // getProfile(json['token'], token, context);
        deleteUserData(context);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false);
    }
  }

  @override
  void initState() {
    getUserTokenMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
