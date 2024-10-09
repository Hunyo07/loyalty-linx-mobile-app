import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/veiws/profile/change_password.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

ValueNotifier<ThemeMode> notifier = ValueNotifier(ThemeMode.light);
bool themeMode = false;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Row(
                children: [
                  const Text("Theme"),
                  const Spacer(),
                  Switch(
                      value: themeMode,
                      onChanged: (value) {
                        if (notifier.value == ThemeMode.light) {
                          setState(() {
                            themeMode = value;
                            notifier.value = ThemeMode.dark;
                          });
                        } else {
                          setState(() {
                            themeMode = value;
                            notifier.value = ThemeMode.light;
                          });
                        }
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ProfileButton(
                title: "Change password",
                icon: Icon(Icons.password_sharp),
                onTap: () {
                  Navigator.pushNamed(context, '/change_password');
                })
          ],
        ),
      )),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final Icon icon;
  final Function onTap;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap();
          }, //add function here to navigate to the specific page
          child: Ink(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height / 12,
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        title,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
