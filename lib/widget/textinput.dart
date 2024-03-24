import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final Icon? prefixIcon;

  const TextInput(
      {super.key,
      required this.controller,
      required this.hint,
      this.isPassword = false, this.prefixIcon});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(15.0),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword ? GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ): null),
    );
  }
}
