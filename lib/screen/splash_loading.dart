import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                'Story App',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.black),
              ),
            ),
          ),
          Positioned(
              left: MediaQuery.of(context).size.width / 2 - 25,
              bottom: 50,
              child: const CircularProgressIndicator())
        ],
      ),
    );
  }
}
