import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro/controllers/user_controller.dart';
import 'package:tadbiro/services/auth/auth_service.dart';
import 'package:tadbiro/views/screens/edit_profile_screen.dart';
import 'package:tadbiro/views/screens/my_events.dart';
import 'package:tadbiro/views/screens/settings_screen.dart';

class DraverWidget extends StatefulWidget {
  const DraverWidget({super.key});

  @override
  State<DraverWidget> createState() => _DraverWidgetState();
}

class _DraverWidgetState extends State<DraverWidget> {
  String userId = '';
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      userId = await AuthService().getUserId();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserController().getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        final userData = snapshot.data!;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              InkWell(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: userData['imageUrl'] != null
                            ? NetworkImage(userData['imageUrl'])
                            : const AssetImage('assets/images/avatar.jpg'),
                        fit: BoxFit.cover),
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        userData['name'],
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        userData['email'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EditProfileScreen(userData: userData),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: Text('my events'.tr()),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => MyEvents()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text('Profile'.tr()),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text('Settings'.tr()),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => SettingsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_medium_sharp),
                title: Text("Change theme".tr()),
                onTap: () {
                  final themeMode = AdaptiveTheme.of(context).mode;
                  if (themeMode == AdaptiveThemeMode.light) {
                    AdaptiveTheme.of(context).setDark();
                  }
                  if (themeMode == AdaptiveThemeMode.dark) {
                    AdaptiveTheme.of(context).setLight();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
