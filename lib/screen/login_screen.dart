import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/widget/textinput.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'LoginScreen';

  final void Function() onTap;

  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      switch (apiProvider.apiResponse.state) {
        case ResultState.Success:
          print('success ${apiProvider.apiResponse.data?.loginResult.name}');
        case ResultState.Error:
          showErrorSnackbar(apiProvider.apiResponse.error ??
              'An error occurred during login.');
        default:
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInput(
              controller: _emailController,
              hint: 'Input email here',
              prefixIcon: const Icon(Icons.account_circle_rounded),
            ),
            const SizedBox(
              height: 16,
            ),
            TextInput(
              controller: _passwordController,
              hint: 'Input password here',
              isPassword: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColorLight),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(15.0),
                ),
              ),
              onPressed: apiProvider.apiResponse.state == ResultState.Loading
                  ? null
                  : () => login(),
              child: apiProvider.apiResponse.state == ResultState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
                onTap: widget.onTap,
                child: const Text(
                  'Create account here',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      )),
    );
  }
}
