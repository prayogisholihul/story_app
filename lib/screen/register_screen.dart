import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('REGISTER'),
        ),
      ),
    );
  }
}
