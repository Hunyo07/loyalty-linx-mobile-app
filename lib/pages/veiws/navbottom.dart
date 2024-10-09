import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/auth/permission_checker.dart';
import 'package:loyaltylinx/pages/veiws/credits.dart';
import 'package:loyaltylinx/pages/veiws/home.dart';
import 'package:loyaltylinx/pages/veiws/myqr.dart';
import 'package:loyaltylinx/pages/veiws/rewards.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:unicons/unicons.dart';

List userData1 = [];
String? profile;

class BottomNavBarExample extends StatefulWidget {
  final List<dynamic> userData;

  const BottomNavBarExample({super.key, required this.userData});

  @override
  State<BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample>
    with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {
      userData1 = widget.userData;
      profile = userData1[0]["profilePicture"];
    });
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  void _onItemTapped(int index) {
    _currentIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    userData1 = widget.userData;
    return Scaffold(
      // appBar: _currentIndex != 3 ? homeAppBar() : null,
      appBar: homeAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: newMethod(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
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
                side: const BorderSide(
                    width: 4,
                    // color: _currentIndex == 1 || _currentIndex == 2
                    //     ? const Color.fromARGB(255, 248, 204, 129)
                    //     : Theme.of(context).colorScheme.primaryContainer,
                    color: Color.fromARGB(255, 248, 204, 129))),
            backgroundColor: const Color.fromARGB(255, 248, 204, 129),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  UniconsLine.qrcode_scan,
                  size: 40,
                  color: Color.fromARGB(255, 31, 21, 80),
                ),
              ],
            )));
  }

  final iconList = <IconData>[
    UniconsLine.home,
    UniconsLine.credit_card,
    UniconsLine.usd_circle,
    UniconsLine.user_circle
  ];

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const CreditPage(),
    const RewardsPage(),
    const ProfilePage(),
  ];
  late PageController _pageController;
  final autoSizeGroup = AutoSizeGroup();

  ClipRRect _buildBottomNavBar() {
    return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(0),
        ),
        child: AnimatedBottomNavigationBar.builder(
            itemCount: _pages.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Colors.amber.shade900 : Colors.black;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                ],
              );
            },
            backgroundColor: const Color.fromARGB(255, 248, 204, 129),
            activeIndex: _currentIndex,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 28,
            rightCornerRadius: 28,
            scaleFactor: BorderSide.strokeAlignCenter,
            onTap: _onItemTapped));
  }

  final Map<int, String> titles = {
    0: 'Home',
    1: 'Credits',
    2: 'Rewards',
    3: 'Profile'
  };

  AppBar homeAppBar() {
    return AppBar(
      title: Text(
        titles[_currentIndex]!,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 204, 129),
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
                icon: const Icon(
                  UniconsLine.bell,
                  color: Colors.black,
                ),
              ),
              CircleAvatar(
                radius: _currentIndex != 3 ? 18 : 0,
                backgroundColor: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    _currentIndex = 3;
                    _pageController.animateToPage(
                      _currentIndex,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.ease,
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(
                              profile!,
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
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
          snapAnimationDuration: const Duration(milliseconds: 400),
          initialChildSize: .60,
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
