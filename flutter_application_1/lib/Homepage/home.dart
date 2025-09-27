import 'package:flutter/material.dart';
import 'add.dart';
import 'list.dart';
import '../widgets/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _selectedIndex = 0; // หน้าแรก
      } else if (index == 1) {
        _selectedIndex = 2; // รายการ (index 2 ใน IndexedStack)
      }
    });
  }

  String getPageName() {
    switch (_selectedIndex) {
      case 0:
        return 'หน้าแรก';
      case 1:
        return 'แจ้งซ่อม';
      case 2:
        return 'รายการ';
      default:
        return 'หน้าแรก';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: getPageName(),
      currentIndex: _selectedIndex,
      onTabSelected: _onItemTapped,
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      onFabPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPage()),
        );
      },
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // หน้าแรก: ว่างเปล่า
          Container(color: Colors.white),
          // หน้าแจ้งซ่อม
          const AddPage(),
          // หน้ารายการ
          const ListPage(),
        ],
      ),
    );
  }
}