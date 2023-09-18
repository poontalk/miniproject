import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obcureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obcureText});

  @override
  Widget build(BuildContext context){
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: controller,
                  obscureText: obcureText,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                   focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                   ),
                   fillColor: Colors.grey.shade200,
                   filled: true,
                   hintText: hintText,
                   hintStyle: TextStyle(color: Colors.grey[500])
                  ),                
                ),
              );
  }
}