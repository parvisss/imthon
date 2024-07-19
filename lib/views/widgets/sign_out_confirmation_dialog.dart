import 'package:flutter/material.dart';
import 'package:tadbiro/services/auth/auth_service.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService().logOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign Out'),
      content: Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _signOut(context),
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}
