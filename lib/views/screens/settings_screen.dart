import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tadbiro/views/screens/change_password_dialog.dart';
import 'package:tadbiro/views/widgets/sign_out_confirmation_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings'.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title:  Text('Change Password'.tr()),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ChangePasswordDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('Change Language'.tr()),
                  trailing: DropdownButton<String>(
                    value: context.locale.languageCode,
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'uz',
                        child: Text('Uzbek'),
                      ),
                      // Add more languages as needed
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.setLocale(Locale(newValue));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title:  Text('Sign Out'.tr()),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SignOutConfirmationDialog();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
