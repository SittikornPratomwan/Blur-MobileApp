import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('การแจ้งเตือน'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'ยังไม่มีการแจ้งเตือน',
          style: TextStyle(color: Colors.deepPurple[700]),
        ),
      ),
    );
  }
}
