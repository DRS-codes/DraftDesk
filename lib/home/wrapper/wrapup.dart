import 'package:draftdesk/authenticate/signin/teacher%20signin/sign_in.dart';

import 'package:draftdesk/assignment%20List/assignment_list.dart';
import 'package:draftdesk/for%20teachers/assignment%20List/addname_screen.dart';
import 'package:flutter/material.dart';

class Wrapup extends StatefulWidget {
  const Wrapup({super.key});

  @override
  State<Wrapup> createState() => _WrapupState();
}

class _WrapupState extends State<Wrapup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        foregroundColor: Colors.white,
        title: Text(
          'Welcome To DraftDesk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let me know your profile',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple[400],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInTeacher()));
              },
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  'Teacher',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssignmentList()));
                // SignInStudent()));
              },
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  'Student',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
