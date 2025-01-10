import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateAssignment extends StatefulWidget {
  final String assignmentId;
  const UpdateAssignment({super.key, required this.assignmentId});

  @override
  State<UpdateAssignment> createState() => _UpdateAssignmentState();
}

class _UpdateAssignmentState extends State<UpdateAssignment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topicController = TextEditingController();
  String? subjectController;
  final List<String> subjects = [
    'Java',
    'Computer Fundamentals',
    'Python',
    'C',
    'C++',
  ];
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
        foregroundColor: Colors.white,
        title: const Text(
          'Update Assignment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('assignments')
            .doc(widget.assignmentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading assignment data.'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('No data found for this assignment.'),
            );
          }

          var assignmentData = snapshot.data!.data() as Map<String, dynamic>?;

          if (assignmentData == null) {
            return const Center(
              child: Text('Assignment data is null.'),
            );
          }

          subjectController = subjectController ?? assignmentData['Subject'];
          topicController.text = assignmentData['Topic'];
          _dateTimeController.text = assignmentData['date'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: subjectController,
                        hint: const Text('Select a subject'),
                        dropdownColor: Colors.deepPurple[400],
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() {
                            subjectController = newValue;
                          });
                        },
                        items: subjects
                            .map<DropdownMenuItem<String>>((String subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(
                              subject,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _dateTimeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Select Date & Time",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () =>
                          _selectDateTime(context), // Open Date & Time Picker
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: topicController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Enter the topic',
                        filled: true,
                        fillColor: Colors.deepPurple[400],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a topic.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[400],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('assignments')
                                .doc(widget.assignmentId)
                                .update({
                              'Subject': subjectController,
                              'Topic': topicController.text,
                              'date': _dateTimeController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Assignment updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
