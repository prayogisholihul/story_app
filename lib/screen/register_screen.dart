import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'RegisterScreen';

  final Function() onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(onTap: widget.onTap,child: const Text('REGISTER')),
        ),
      ),
    );
  }
}
