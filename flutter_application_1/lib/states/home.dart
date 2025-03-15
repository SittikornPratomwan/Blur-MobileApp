import 'package:flutter/material.dart';
import 'package:flutter_application_1/wiged/signout.dart';
import 'package:flutter_application_1/states/addblacklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png', height: 50),
            SizedBox(width: 10),
            Text(
              'Blacklistseller',
              style: TextStyle(fontWeight: FontWeight.bold), // Make the title bold
            ),
          ],
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.orange, // เปลี่ยนสีของ AppBar เป็นสีส้ม
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Signout(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBlacklistPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.black), // เปลี่ยนสีของไอคอนเป็นสีแดง
        backgroundColor: Colors.orange, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีม่วง
        foregroundColor: Colors.white, // เปลี่ยนสีของไอคอนเป็นสีขาว
        elevation: 10.0, // ปรับระดับความสูงของเงา
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blacklist')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          User? currentUser = FirebaseAuth.instance.currentUser;

          return ListView(
            children: [
              ...snapshot.data!.docs.take(12).map((document) {
                final data = document.data() as Map<String, dynamic>;
                bool isOwner = data['email'] == currentUser?.email;
                Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                DateTime dateTime = timestamp.toDate();
                String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

                return Slidable(
                  key: ValueKey(document.id),
                  enabled: isOwner, // Disable Slidable if not the owner
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _showEditDialog(document.id, data);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          _showDeleteConfirmationDialog(document.id);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${data['firstName']} ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: data['lastName'],
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Account Number: ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '${data['accountNumber']}',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                          Text('Trade Channel: ${data['tradeChannel']}'),
                          Text('Product: ${data['product']}'),
                          Text('Amount: ${data['amount']}'), // แสดงจำนวนเงิน
                          Text('Date: $formattedDate'), // แสดงวันที่
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'แสดงรายงานล่าสุดเพียง 12 รายงาน หากต้องการตรวจสอบให้คลิกปุ่มค้นหา',
                    
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditDialog(String documentId, Map<String, dynamic> data) {
    TextEditingController firstNameController = TextEditingController(text: data['firstName']);
    TextEditingController lastNameController = TextEditingController(text: data['lastName']);
    TextEditingController accountNumberController = TextEditingController(text: data['accountNumber']);
    TextEditingController tradeChannelController = TextEditingController(text: data['tradeChannel']);
    TextEditingController productController = TextEditingController(text: data['product']);
    TextEditingController amountController = TextEditingController(text: data['amount']); // เพิ่ม TextEditingController สำหรับจำนวนเงิน

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(labelText: 'Account Number'),
                ),
                TextField(
                  controller: tradeChannelController,
                  decoration: InputDecoration(labelText: 'Trade Channel'),
                ),
                TextField(
                  controller: productController,
                  decoration: InputDecoration(labelText: 'Product'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'), // เพิ่มช่องสำหรับจำนวนเงิน
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateDocument(
                  documentId,
                  firstNameController.text,
                  lastNameController.text,
                  accountNumberController.text,
                  tradeChannelController.text,
                  productController.text,
                  amountController.text, // เพิ่มการอัปเดตจำนวนเงิน
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateDocument(
    String documentId,
    String firstName,
    String lastName,
    String accountNumber,
    String tradeChannel,
    String product,
    String amount, // เพิ่มพารามิเตอร์สำหรับจำนวนเงิน
  ) {
    FirebaseFirestore.instance.collection('blacklist').doc(documentId).update({
      'firstName': firstName,
      'lastName': lastName,
      'accountNumber': accountNumber,
      'tradeChannel': tradeChannel,
      'product': product,
      'amount': amount, // เพิ่มการอัปเดตจำนวนเงิน
      'timestamp': FieldValue.serverTimestamp(), // เพิ่มฟิลด์ timestamp
    });
  }

  void _showDeleteConfirmationDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบรายการนี้หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                _deleteDocument(documentId);
                Navigator.of(context).pop();
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDocument(String documentId) {
    FirebaseFirestore.instance.collection('blacklist').doc(documentId).delete();
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('การอนุญาตถูกปฏิเสธ'),
          content: Text('คุณไม่มีสิทธิ์ในการแก้ไขหรือลบรายงานนี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange, // เปลี่ยนสีของ AppBar เป็นสีส้ม
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blacklist').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data!.docs.where((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          return data['firstName'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['lastName'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['accountNumber'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['product'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();

        return ListView(
          children: results.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('${data['firstName']} ${data['lastName']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Number: ${data['accountNumber']}'),
                    Text('Trade Channel: ${data['tradeChannel']}'),
                    Text('Product: ${data['product']}'),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blacklist').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data!.docs.where((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          return data['firstName'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['lastName'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['accountNumber'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['product'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();

        return ListView(
          children: results.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text('${data['firstName']} ${data['lastName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Number: ${data['accountNumber']}'),
                  Text('Trade Channel: ${data['tradeChannel']}'),
                  Text('Product: ${data['product']}'),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}