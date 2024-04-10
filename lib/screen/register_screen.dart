import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/constant.dart';

import '../common/result.dart';
import '../provider/auth_provider.dart';
import '../widget/button_style.dart';
import '../widget/textinput.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'RegisterScreen';

  final Function() onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = context.watch<AuthProvider>();

    void register(String name, String email, String password) async {
      await apiProvider.register(name, email, password);

      switch (apiProvider.registerResult.state) {
        case ResultState.Success:
          showSnackbar('Success create account');
          widget.onTap();
          break;
        case ResultState.Error:
          showSnackbar(
              apiProvider.registerResult.message ?? Constant.errorMessage);
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
                'Register',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 16,
              ),
              TextInput(
                controller: _nameController,
                hint: 'name',
                prefixIcon: const Icon(Icons.account_circle_rounded),
              ),
              const SizedBox(
                height: 16,
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
                titleButton: 'Register',
                isLoading:
                    apiProvider.registerResult.state == ResultState.Loading,
                onTap: () {
                  register(_nameController.text, _emailController.text,
                      _passwordController.text);
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 4,),
                  InkWell(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
