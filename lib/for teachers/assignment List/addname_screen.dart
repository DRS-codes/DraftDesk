import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:draftdesk/for%20teachers/add%20assignment/add_assignment.dart';
import 'package:draftdesk/for%20teachers/update_assignment/update_assignment.dart';

import 'package:flutter/material.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Assignments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[400],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAssignment()));
        },
        child: Icon(Icons.add),
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
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateAssignment(
                                          assignmentId: assignment.id,
                                        )));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                      title: Text(
                        '${assignment['Subject']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            var collection = FirebaseFirestore.instance
                                .collection('assignments');
                            collection.doc(assignment.id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Assignment deleted successfully!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                        ),
                        child: Text(
                          'Topic - ${assignment['Topic']}',
                          maxLines: 200,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
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
