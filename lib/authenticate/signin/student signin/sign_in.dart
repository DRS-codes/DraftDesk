import 'package:flutter/material.dart';

class SignInStudent extends StatefulWidget {
  const SignInStudent({super.key});

  @override
  State<SignInStudent> createState() => _SignInStudentState();
}

class _SignInStudentState extends State<SignInStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Sign-in'),
      ),
    );
  }
}
