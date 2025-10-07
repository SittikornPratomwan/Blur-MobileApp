import 'package:flutter/material.dart';
import '../post.dart';
import '../list.dart';
import 'home_tab.dart';
import 'trending_tab.dart';
import '../../widgets/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        return 'Public';
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
          // หน้าแรก: มีแถบแท็บ
          Column(
            children: [
              // แถบแท็บใต้ชื่อ "หน้าแรก"
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'หน้าแรก'),
                    Tab(text: 'มาแรง'),
                  ],
                ),
              ),
              // เนื้อหาของแท็บ
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    HomeTab(),
                    TrendingTab(),
                  ],
                ),
              ),
            ],
          ),
          // หน้าแจ้งซ่อม
          const AddPage(),
          // หน้ารายการ
          const ListPage(),
        ],
      ),
    );
  }
}