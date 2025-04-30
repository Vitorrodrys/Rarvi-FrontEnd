import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final double radius;
  final double? width;
  final double? height;
  final bool isPassword;
  final TextInputType? keyboardType;

  const RoundedTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.radius,
    this.width,
    this.height,
    this.isPassword = false,
    this.keyboardType
  });

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}




class _RoundedTextFieldState extends State<RoundedTextField> {


  late bool _obscureText;

  @override
  void initState(){
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    IconButton? suffixIcon = widget.isPassword
        ? IconButton(
            icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
        : null;
    return TextField(
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black54
          ),
          prefixIcon: Icon(widget.icon, color: Colors.black54),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      );
  }
}
