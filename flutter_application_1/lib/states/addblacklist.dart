import 'package:flutter/material.dart';
import 'package:flutter_application_1/states/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddBlacklistPage extends StatefulWidget {
  @override
  _AddBlacklistPageState createState() => _AddBlacklistPageState();
}

class _AddBlacklistPageState extends State<AddBlacklistPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _tradeChannelController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(); // เพิ่ม TextEditingController สำหรับจำนวนเงิน

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _accountNumberController.dispose();
    _tradeChannelController.dispose();
    _productController.dispose();
    _amountController.dispose(); // เพิ่มการ dispose สำหรับจำนวนเงิน
    super.dispose();
  }

  void _saveData() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String accountNumber = _accountNumberController.text;
    final String tradeChannel = _tradeChannelController.text;
    final String product = _productController.text;
    final String amount = _amountController.text; // เพิ่มการเก็บข้อมูลจำนวนเงิน

    if (firstName.isEmpty || lastName.isEmpty || accountNumber.isEmpty || tradeChannel.isEmpty || product.isEmpty || amount.isEmpty) {
      _showErrorDialog();
      return;
    }

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Save data to Firestore
      await FirebaseFirestore.instance.collection('blacklist').add({
        'firstName': firstName,
        'lastName': lastName,
        'accountNumber': accountNumber,
        'tradeChannel': tradeChannel,
        'product': product,
        'amount': amount, // เพิ่มการบันทึกจำนวนเงิน
        'email': user.email, // Save email instead of userId
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Print data to console
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Account Number: $accountNumber');
      print('Trade Channel: $tradeChannel');
      print('Product: $product');
      print('Amount: $amount'); // เพิ่มการพิมพ์จำนวนเงิน
      print('Email: ${user.email}');

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ข้อมูลไม่ครบถ้วน'),
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วนทุกช่อง'),
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการบันทึกข้อมูล'),
          content: Text('ถ้าหากข้อมูลเป็นเท็จจะมีความผิดทางกฎหมาย คุณต้องการบันทึกข้อมูลหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveData();
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Blacklist'),
        centerTitle: true, // ทำให้คำว่า Add to Blacklist อยู่ตรงกลาง
        backgroundColor: Colors.orange, // เปลี่ยนสีของ AppBar เป็นสีส้ม
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ให้ใส่ชื่อมิจฉาชีพหรือคนขาย ไม่ใช่ชื่อตัวเอง❌ (ไม่ต้องใส่นาย หรือนางสาว หรือนาง )',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อบัญชีคนขาย',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'นามสกุลบัญชีคนขาย',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number, // ให้ใส่เป็นตัวเลขเท่านั้น
              decoration: InputDecoration(
                labelText: 'เลขบัญชีคนขาย',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tradeChannelController,
              decoration: InputDecoration(
                labelText: 'ช่องทางการซื้อขาย',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productController,
              decoration: InputDecoration(
                labelText: 'สินค้าที่สั่งซื้อ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number, // ให้ใส่เป็นตัวเลขเท่านั้น
              decoration: InputDecoration(
                labelText: 'จำนวนเงิน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ไม่อนุญาตให้ลงรายงานเกี่ยวกับ แชร์ ยืมเงิน/ออมเงิน ไอดีเกมส์ รหัสเกม',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // เปลี่ยนสีของปุ่มเป็นสีแดง
                ),
                child: Text('บันทึกข้อมูล', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}