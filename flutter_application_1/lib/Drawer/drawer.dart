import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'setting.dart';
import 'history.dart';
import '../Authen/services/auth_service.dart';
import '../Authen/login_page.dart';

/// Reusable app drawer moved out of home.dart
class AppDrawer extends StatelessWidget {
  final void Function(int index)? onPageChanged;
  final AuthService _authService = AuthService();

  AppDrawer({Key? key, this.onPageChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple[300]!, Colors.deepPurple[200]!],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.displayName ?? 'ผู้ใช้งาน',
                              style: const TextStyle(color: Colors.white, fontSize: 18)
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.data!.email ?? 'ไม่มีอีเมล',
                              style: const TextStyle(color: Colors.white70, fontSize: 12)
                            ),
                          ],
                        );
                      } else {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ผู้ใช้งาน',
                                style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(height: 4),
                            Text('กรุณาเข้าสู่ระบบ',
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('history'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HistoryPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                // Navigate directly to the settings page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingPage(),
                  ),
                );
              },
            ),
            const Spacer(), // Push logout to bottom
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    await _authService.signOut();
                    // Navigate to login page and clear all previous routes
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    // Show error if logout fails
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
