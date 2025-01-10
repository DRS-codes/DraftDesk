import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  List<String> subjects = [
    'Java',
    'Computer fundamentals',
    'Python',
    'C',
    'C++'
  ];
  final topicController = TextEditingController();
  String? subjectController;
  final TextEditingController _dateTimeController = TextEditingController();

  // Function to select a date
  Future<void> _selectDateTime(BuildContext context) async {
    // Step 1: Select Date
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (selectedDate != null) {
      // Step 2: Select Time
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(), // Default time
      );

      if (selectedTime != null) {
        // Combine Date and Time
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Format the DateTime for display
        String formattedDateTime =
            "${finalDateTime.day}-${finalDateTime.month}-${finalDateTime.year} ${finalDateTime.hour}:${finalDateTime.minute.toString().padLeft(2, '0')}";

        setState(() {
          _dateTimeController.text = formattedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Give Assignments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.deepPurple[400],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.deepPurple[400],
                  isExpanded: true,
                  value: subjectController,
                  hint: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Select a subject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      subjectController = newValue;
                    });
                  },
                  items:
                      subjects.map<DropdownMenuItem<String>>((String subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child:
                          Text(subject, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepPurple[400],
                    labelText: 'Topic',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: topicController,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Date & Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () =>
                    _selectDateTime(context), // Open Date & Time Picker
              ),
              GestureDetector(
                onTap: () async {
                  // Reference to the Firestore collection
                  CollectionReference collectionReference =
                      FirebaseFirestore.instance.collection('assignments');

                  // Add a new document to Firestore and get the document reference
                  await collectionReference.add({
                    'Subject': subjectController,
                    'Topic': topicController.text,
                    'date': _dateTimeController.text,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Assignment Added'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
