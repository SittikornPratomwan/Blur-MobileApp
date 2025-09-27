import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _soundEnabled = true;
  String _language = 'ไทย';
  String _fontSize = 'ปานกลาง';
  bool _biometricAuth = false;
  bool _dataSaver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('การตั้งค่า'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          _buildSectionHeader('โปรไฟล์'),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple[100],
                child: Icon(Icons.person, color: Colors.deepPurple[700]),
              ),
              title: const Text('User Name'),
              subtitle: const Text('user@example.com'),
              trailing: Icon(Icons.edit, color: Colors.deepPurple[700]),
              onTap: () {
                _showEditProfileDialog();
              },
            ),
          ),
          const SizedBox(height: 20),

          // Notifications Section
          _buildSectionHeader('การแจ้งเตือน'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('เปิดการแจ้งเตือน'),
                  subtitle: const Text('รับการแจ้งเตือนจากแอป'),
                  value: _notificationsEnabled,
                  activeColor: Colors.deepPurple,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('เสียงแจ้งเตือน'),
                  subtitle: const Text('เปิด/ปิดเสียงแจ้งเตือน'),
                  value: _soundEnabled,
                  activeColor: Colors.deepPurple,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display Section
          _buildSectionHeader('การแสดงผล'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('โหมดมืด'),
                  subtitle: const Text('เปลี่ยนธีมเป็นสีเข้ม'),
                  value: _darkMode,
                  activeColor: Colors.deepPurple,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_darkMode ? 'เปิดโหมดมืด' : 'ปิดโหมดมืด'),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('ขนาดตัวอักษร'),
                  subtitle: Text('ขนาด: $_fontSize'),
                  trailing: Icon(Icons.text_fields, color: Colors.deepPurple[700]),
                  onTap: () {
                    _showFontSizeDialog();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Language Section
          _buildSectionHeader('ภาษา'),
          Card(
            child: ListTile(
              title: const Text('ภาษาแอป'),
              subtitle: Text('ภาษาปัจจุบัน: $_language'),
              trailing: Icon(Icons.language, color: Colors.deepPurple[700]),
              onTap: () {
                _showLanguageDialog();
              },
            ),
          ),
          const SizedBox(height: 20),

          // Security Section
          _buildSectionHeader('ความปลอดภัย'),
          Card(
            child: SwitchListTile(
              title: const Text('ล็อกอินด้วยไบโอเมตริกส์'),
              subtitle: const Text('สแกนลายนิ้วมือ/ใบหน้าเพื่อเข้าสู่ระบบ'),
              value: _biometricAuth,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _biometricAuth = value);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Data and Network Section
          _buildSectionHeader('ดาต้าและการเชื่อมต่อ'),
          Card(
            child: SwitchListTile(
              title: const Text('โหมดประหยัดดาต้า'),
              subtitle: const Text('ลดการใช้ดาต้าขณะใช้งานแอป'),
              value: _dataSaver,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _dataSaver = value);
              },
            ),
          ),
          const SizedBox(height: 20),

          // About Section
          _buildSectionHeader('เกี่ยวกับ'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('เวอร์ชันแอป'),
                  subtitle: const Text('1.0.0'),
                  leading: Icon(Icons.info, color: Colors.deepPurple[700]),
                ),
                ListTile(
                  title: const Text('นโยบายความเป็นส่วนตัว'),
                  leading: Icon(Icons.privacy_tip, color: Colors.deepPurple[700]),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เปิดนโยบายความเป็นส่วนตัว')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('เงื่อนไขการใช้งาน'),
                  leading: Icon(Icons.description, color: Colors.deepPurple[700]),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เปิดเงื่อนไขการใช้งาน')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Danger Zone
          _buildSectionHeader('อื่นๆ'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('ล้างข้อมูลแคช'),
                  subtitle: const Text('ลบข้อมูลชั่วคราวที่เก็บไว้'),
                  leading: Icon(Icons.cleaning_services, color: Colors.orange[700]),
                  onTap: () {
                    _showClearCacheDialog();
                  },
                ),
                ListTile(
                  title: const Text('ลบบัญชี', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('การกระทำนี้ไม่สามารถย้อนกลับได้'),
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[700],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แก้ไขโปรไฟล์'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              decoration: InputDecoration(labelText: 'ชื่อ'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('บันทึก', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกขนาดตัวอักษร'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('เล็ก'),
              value: 'เล็ก',
              groupValue: _fontSize,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _fontSize = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('ปานกลาง'),
              value: 'ปานกลาง',
              groupValue: _fontSize,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _fontSize = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('ใหญ่'),
              value: 'ใหญ่',
              groupValue: _fontSize,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _fontSize = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกภาษา'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('ไทย'),
              value: 'ไทย',
              groupValue: _language,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ล้างข้อมูลแคช'),
        content: const Text('คุณต้องการล้างข้อมูลแคชหรือไม่? การกระทำนี้จะช่วยให้แอปทำงานเร็วขึ้น'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ล้างข้อมูลแคชเรียบร้อย'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('ล้างข้อมูล', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบบัญชี'),
        content: const Text('คุณแน่ใจหรือไม่ที่จะลบบัญชี? การกระทำนี้ไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ยกเลิกการลบบัญชี'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบบัญชี', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
