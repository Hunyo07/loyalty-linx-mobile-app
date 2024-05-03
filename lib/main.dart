// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/auth/create_acc_number.dart';
import 'package:loyaltylinx/pages/auth/home_login.dart';
import 'package:loyaltylinx/pages/auth/link_card.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/auth/register.dart';
import 'package:loyaltylinx/pages/theme/dark_theme.dart';
import 'package:loyaltylinx/pages/theme/light_theme.dart';
import 'package:loyaltylinx/pages/veiws/home.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/reward_transaction.dart';
import 'package:loyaltylinx/pages/veiws/rewards.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:loyaltylinx/pages/veiws/transaction_credit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

List<Object>? userData0;
String profile = "";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Object? token;

  Future<void> deleteUserData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_data');
    getProfile(token, context);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
    getUserData();
  }

  Future<void> getProfile(String token, context) async {
    final response = await http.get(
      Uri.parse('https://loyaltylinx.cyclic.app/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      saveUserData(
        json['userProfile'],
      );
    } else {}
  }

  Future<void> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('user_token');
    if (token != null) {
      final json = jsonDecode(token.toString());
      deleteUserData(json['token']);
    } else {
      debugPrint('User token not found');
    }
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      userData0 = [jsonDecode(userData)];
    } else {
      debugPrint('User data not found');
    }
    setState(() {});
  }

  @override
  void initState() {
    setState(() {});
    getUserToken();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => token == null
                  ? const HomeView()
                  : BottomNavBarExample(
                      userData: userData0!,
                    )),
          (route) => false);
    });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
      // home: const HomeView(),
      routes: {
        '/transactions_credit': (context) => const Transaction(),
        '/home': (context) => const HomePage(),
        '/rewards': (context) => const RewardsPage(),
        '/profile': (context) => ProfilePage(
              userData: [userData0!],
            ),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterView(),
        '/bottomnavbar': (context) => BottomNavBarExample(
              userData: [userData0!],
            ),
        '/homeView': (context) => const HomeView(),
        '/numberRegister': (context) => const NumberRegister(),
        '/linkCard': (context) => const LinkCard(),
        '/transactions_reward': (context) => const TransactionRewards(),
      },
    );
  }
}
