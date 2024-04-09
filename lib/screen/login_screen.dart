import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/widget/button_style.dart';
import 'package:story_app/widget/textinput.dart';

import '../common/constant.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'LoginScreen';

  final void Function() toRegister;
  final void Function() toMain;

  const LoginScreen(
      {super.key, required this.toRegister, required this.toMain});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = context.watch<AuthProvider>();

    showErrorSnackbar(String errorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }

    void login() async {
      await apiProvider.login(_emailController.text, _passwordController.text);
      switch (apiProvider.loginResult.state) {
        case ResultState.Success:
          widget.toMain();
          break;
        case ResultState.Error:
          showErrorSnackbar(
              apiProvider.loginResult.message ?? Constant.errorMessage);
          break;
        default:
          break;
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log In',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 24,
            ),
            TextInput(
              controller: _emailController,
              hint: 'email',
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(
              height: 16,
            ),
            TextInput(
              controller: _passwordController,
              hint: 'password',
              isPassword: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 24),
            ButtonRounded(
                titleButton: 'Login',
                isLoading: apiProvider.loginResult.state == ResultState.Loading,
                onTap: login),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 4,),
                InkWell(
                    onTap: widget.toRegister,
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}
