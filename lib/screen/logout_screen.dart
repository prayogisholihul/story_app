import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {

  final void Function() onCancel;
  final void Function() onLogout;
  const LogoutDialog({super.key, required this.onCancel, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: AlertDialog(
        title: const Text('Warning!'),
        content: const Text('Are you sure to logout?'),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onLogout,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
