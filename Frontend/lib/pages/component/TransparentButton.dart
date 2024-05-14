import 'package:flutter/material.dart';

class TransparentButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const TransparentButton({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  _TransparentButtonState createState() => _TransparentButtonState();
}

class _TransparentButtonState extends State<TransparentButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: _isPressed ? Colors.transparent : Colors.transparent, // Adjust border color based on press state
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: widget.child,
      ),
    );
  }
}