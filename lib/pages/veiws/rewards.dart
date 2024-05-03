import 'package:flutter/material.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.
    return const RewardView();
  }
}

final List<Map<String, Object>> mechants = [
  {"path": "assets/images/amazon.png"},
  {"path": "assets/images/sm.png"},
  {"path": "assets/images/mcdo.png"},
  {"path": "assets/images/jollibee.png"},
  {"path": "assets/images/walmart.png"},
  {"path": "assets/images/super8.jpg"},
];

const number = 2000.24;

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.

    return const MyBodyWidget();
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var planets = {
          "first": "earth",
          "second": "mars",
          "third": "jupiter",
          "fourth": "saturn",
          2: "sando"
        };
        planets[1] = "uranus";
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 255, 214, 64),
        elevation: 0,
      ),
      child: Column(
        children: [Container()],
      ),
    );
  }
}

class MyBodyWidget extends StatelessWidget {
  const MyBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    SizedBox buttons(onPress, pathLight, title, pathDark) {
      return SizedBox(
        width: 64,
        child: InkWell(
            onTap: () {
              onPress();
            },
            child: Column(
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: isDark
                      ? Image.asset(
                          pathLight,
                          fit: BoxFit.scaleDown,
                        )
                      : Image.asset(pathDark, fit: BoxFit.scaleDown),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )),
      );
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 248, 204, 129),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width / 1,
            child: Column(
              children: [
                FittedBox(
                  child: Center(
                    child: Text(
                      "Points balance",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Container(
                      // height: MediaQuery.of(context).size.height * .04,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        child: const Center(
                          child: Text(
                            " $number",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 150, 70, 9)),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttons(
            () {},
            'assets/icons/conversionLight.png',
            "Conversion",
            'assets/icons/conversion-rate.png',
          ),
          buttons(() {}, 'assets/icons/giftLight.png', "Redeem",
              'assets/icons/gift.png'),
          buttons(() {}, 'assets/icons/shopLight.png', "Shop",
              'assets/icons/shop.png'),
          buttons(() {
            Navigator.pushNamed(context, '/transactions_reward');
          }, 'assets/icons/historyLight.png', "History",
              'assets/icons/history.png'),
        ],
      ),
      const SizedBox(height: 16.0),
      Container(
        margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade500))),
        child: const Row(
          children: [
            Text(
              "Merchants",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            physics: const ClampingScrollPhysics(),
            itemCount: mechants.length,
            itemBuilder: (BuildContext context, int index) {
              final path = mechants[index]["path"];
              return merchant(context, path, () {});
            },
          )),
      const SizedBox(height: 30.0),
    ]));
  }

  InkWell merchant(BuildContext context, path, onTap) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        width: MediaQuery.of(context).size.width * .16,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage(path), fit: BoxFit.scaleDown)),
      ),
    );
  }
}
