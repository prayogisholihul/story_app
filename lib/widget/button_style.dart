import 'package:flutter/material.dart';

class ButtonRounded extends StatefulWidget {
  final void Function() onTap;
  final String titleButton;
  final bool isLoading;

  const ButtonRounded(
      {super.key,
      required this.titleButton,
      required this.isLoading,
      required this.onTap});

  @override
  State<ButtonRounded> createState() => _ButtonRoundedState();
}

class _ButtonRoundedState extends State<ButtonRounded> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
      onPressed: widget.isLoading ? null : widget.onTap,
      child: widget.isLoading
          ? const Center(child: SizedBox(height: 24, width: 24,child: CircularProgressIndicator()))
          : Center(
              child: Text(
                widget.titleButton,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
    );
  }
}
