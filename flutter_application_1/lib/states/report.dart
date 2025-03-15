import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _issueController = TextEditingController();

    void _submitReport() async {
      final String issue = _issueController.text;
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && issue.isNotEmpty) {
        await FirebaseFirestore.instance.collection('reports').add({
          'issue': issue,
          'email': user.email,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the text field
        _issueController.clear();

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รายงานของคุณถูกส่งเรียบร้อยแล้ว')),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานปัญหา'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                labelText: 'ต้องการรายงานปัญหาอะไร',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text('ส่งรายงาน'),
            ),
          ],
        ),
      ),
    );
  }
}