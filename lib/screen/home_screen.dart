import 'package:flutter/material.dart';
import 'package:story_app/widget/button_style.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final void Function() onTap;

  const HomeScreen({super.key, required this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('HOME SCREEN'),
                const SizedBox(
                  height: 24,
                ),
                ButtonRounded(
                    titleButton: 'Logout',
                    isLoading: false,
                    onTap: widget.onTap)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
