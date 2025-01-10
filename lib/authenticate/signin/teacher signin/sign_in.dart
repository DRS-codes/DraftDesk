import 'package:draftdesk/for%20teachers/assignment%20List/addname_screen.dart';
import 'package:flutter/material.dart';

class SignInTeacher extends StatefulWidget {
  const SignInTeacher({super.key});

  @override
  State<SignInTeacher> createState() => _SignInTeacherState();
}

class _SignInTeacherState extends State<SignInTeacher> {
  TextEditingController _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple[400],
        title: Text(
          'Teacher Sign-in',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  labelText: 'Enter code',
                ),
                keyboardType: TextInputType.number,
                controller: _codeController,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                onTap: () {
                  if (_codeController.text == '00') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssignmentScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wrong Code'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
