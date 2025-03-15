import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/states/home.dart'; // เพิ่มการนำเข้า home.dart
import 'package:flutter_slidable/flutter_slidable.dart'; // เพิ่มการนำเข้า flutter_slidable

class PeopleIReported extends StatelessWidget {
  const PeopleIReported({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานที่ฉันสร้าง'),
        backgroundColor: Colors.orange,
        centerTitle: true, // ทำให้ข้อความอยู่ตรงกลาง
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homepage()), // นำทางไปที่หน้า home.dart
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blacklist')
            .where('email', isEqualTo: currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final data = document.data() as Map<String, dynamic>;

              return Slidable(
                key: ValueKey(document.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        if (data['email'] == currentUser?.email) {
                          _showEditDialog(context, document.id, data);
                        } else {
                          _showPermissionDeniedDialog(context);
                        }
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'แก้ไข',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        if (data['email'] == currentUser?.email) {
                          _showDeleteConfirmationDialog(context, document.id);
                        } else {
                          _showPermissionDeniedDialog(context);
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'ลบ',
                    ),
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('${data['firstName']} ${data['lastName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('หมายเลขบัญชี: ${data['accountNumber']}'),
                        Text('ช่องทางการซื้อขาย: ${data['tradeChannel']}'),
                        Text('สินค้า: ${data['product']}'),
                        Text('จำนวนเงิน: ${data['amount']}'),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String documentId, Map<String, dynamic> data) {
    TextEditingController firstNameController = TextEditingController(text: data['firstName']);
    TextEditingController lastNameController = TextEditingController(text: data['lastName']);
    TextEditingController accountNumberController = TextEditingController(text: data['accountNumber']);
    TextEditingController tradeChannelController = TextEditingController(text: data['tradeChannel']);
    TextEditingController productController = TextEditingController(text: data['product']);
    TextEditingController amountController = TextEditingController(text: data['amount']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขรายงาน'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'ชื่อจริง'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'นามสกุล'),
                ),
                TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(labelText: 'หมายเลขบัญชี'),
                ),
                TextField(
                  controller: tradeChannelController,
                  decoration: InputDecoration(labelText: 'ช่องทางการซื้อขาย'),
                ),
                TextField(
                  controller: productController,
                  decoration: InputDecoration(labelText: 'สินค้า'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'จำนวนเงิน'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
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
                  amountController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('บันทึก'),
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
    String amount,
  ) {
    FirebaseFirestore.instance.collection('blacklist').doc(documentId).update({
      'firstName': firstName,
      'lastName': lastName,
      'accountNumber': accountNumber,
      'tradeChannel': tradeChannel,
      'product': product,
      'amount': amount,
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลบรายงาน'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบรายงานนี้?'),
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
              child: Text('ลบ'),
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