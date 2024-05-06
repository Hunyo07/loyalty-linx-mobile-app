import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/auth/permission_checker.dart';
import 'package:loyaltylinx/pages/veiws/credits.dart';
import 'package:loyaltylinx/pages/veiws/home.dart';
import 'package:loyaltylinx/pages/veiws/myqr.dart';
import 'package:loyaltylinx/pages/veiws/rewards.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';

List userData1 = [];
String? profile;

class BottomNavBarExample extends StatefulWidget {
  final List<dynamic> userData;

  const BottomNavBarExample({super.key, required this.userData});

  @override
  State<BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  @override
  Widget build(BuildContext context) {
    userData1 = widget.userData;
    return Scaffold(
      appBar: homeAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: newMethod(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void initState() {
    setState(() {
      userData1 = widget.userData;
      profile = userData1[0]["profilePicture"];
    });
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  SizedBox newMethod() {
    return SizedBox(
        height: 64,
        width: 64,
        child: FloatingActionButton(
            elevation: 0,
            onPressed: () async {
              Permission_checker();
              showQRCodeModal(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(
                  width: 4,
                  color: _currentIndex == 1 || _currentIndex == 2
                      ? const Color.fromARGB(255, 248, 204, 129)
                      : Theme.of(context).colorScheme.primaryContainer,
                )),
            backgroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  size: 40,
                  color: Color.fromARGB(255, 31, 21, 80),
                ),
              ],
            )));
  }

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const RewardsPage(),
    const CreditPage(),
    const ProfilePage(),
  ];
  late PageController _pageController;

  ClipRRect _buildBottomNavBar() {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 350),
                curve: Curves.ease,
              );
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_alt_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Icon(
                  CupertinoIcons.gift_fill,
                ),
              ),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Icon(CupertinoIcons.creditcard_fill),
              ),
              label: 'Credits',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt_circle_fill),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.amber.shade900,
          unselectedItemColor: _currentIndex == 0 && isDark
              ? Colors.white
              : _currentIndex == 3 && isDark
                  ? Colors.white
                  : Colors.black,
          iconSize: 20,
          backgroundColor: _currentIndex == 1 || _currentIndex == 2
              ? const Color.fromARGB(255, 248, 204, 129)
              : Theme.of(context).colorScheme.primaryContainer,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }

  final appBarGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.blueAccent, Colors.purpleAccent],
  );
  AppBar homeAppBar() {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    return AppBar(
      title: Text(
        _currentIndex == 0
            ? "Home"
            : _currentIndex == 1
                ? "Rewards"
                : _currentIndex == 2
                    ? "Credits"
                    : "Profile",
        style: TextStyle(
            color: _currentIndex == 1 || _currentIndex == 2
                ? Colors.black87
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600),
      ),
      backgroundColor: _currentIndex == 1 || _currentIndex == 2
          ? const Color.fromARGB(255, 248, 204, 129)
          : Theme.of(context).colorScheme.background,
      elevation: 0,
      leading: null,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.notifications,
                  color: _currentIndex == 1 || _currentIndex == 2
                      ? Colors.black87
                      : Theme.of(context).colorScheme.primary,
                  size: 35,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                      _pageController.animateToPage(
                        _currentIndex,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.ease,
                      );
                    });
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .09,
                        height: MediaQuery.of(context).size.height * .09,
                        child: Image.network(
                          profile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  PageView _buildPageView() {
    return PageView.builder(
      itemCount: _pages.length,
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return _pages[index];
      },
    );
  }
}

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(0, 255, 214, 64),
          elevation: 0,
          padding: const EdgeInsets.all(2)),
      child: Center(
          child: Icon(
        Icons.arrow_back,
        color: Colors.amber.shade800,
      )),
    );
  }
}

void showQRCodeModal(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          initialChildSize: 0.60,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return const ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: MyQrPage());
          });
    },
  );
}

PageRouteBuilder<dynamic> routeTransition(screenView) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => screenView,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
            child: child,
          ));
    },
  );
}
