import 'package:flutter/material.dart';

class AnimatedInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const AnimatedInputField({Key? key, required this.label, required this.controller}) : super(key: key);

  @override
  _AnimatedInputFieldState createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),  // Duration of the border color change animation
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: _isFocused ? Colors.blue : Colors.grey),  // Change border color on focus
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;  // Track the focus state
          });
        },
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
