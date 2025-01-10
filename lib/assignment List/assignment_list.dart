import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssignmentList extends StatefulWidget {
  const AssignmentList({super.key});

  @override
  State<AssignmentList> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('assignments').snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          // Handle empty data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No assignments available.'));
          }

          // Map the data to widgets
          final assignments = snapshot.data?.docs.reversed.toList();
          List<Widget> assignmentWidgets = [];

          for (var assignment in assignments!) {
            final assignmentWidget = Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.deepPurple[400],
                    ),
                    child: ListTile(
                      title: Text(
                        '${assignment['Subject']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Topic - ${assignment['Topic']}',
                          maxLines: 200,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[400],
                          ),
                          child: Text(
                            'Submission - ${assignment['date']}',
                            maxLines: 200,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
            assignmentWidgets.add(assignmentWidget);
          }

          // Return ListView with assignment widgets
          return ListView(
            children: assignmentWidgets,
          );
        },
      ),
    );
  }
}
