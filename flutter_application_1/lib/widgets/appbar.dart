import 'package:flutter/material.dart';
import '../Drawer/drawer.dart';
import '../Homepage/notification.dart';

typedef TabSelectedCallback = void Function(int index);

class AppScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final TabSelectedCallback onTabSelected;
  final VoidCallback? onFabPressed;
  final IconData? fabIcon;
  final Color? fabColor;
  final double? fabOffsetY;
  final String? title;
  final void Function(int index)? onPageChanged;

  const AppScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
    this.onFabPressed,
    this.fabIcon,
    this.fabColor,
    this.fabOffsetY,
    this.title,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _unreadNotificationCount = 2;

  @override
  void initState() {
    super.initState();
    _simulateNotificationUpdates();
  }

  void _simulateNotificationUpdates() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _unreadNotificationCount += 1;
        });
        _simulateNotificationUpdates();
      }
    });
  }

//-----------------------------Notification Icon-------------------------

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        const Icon(Icons.notifications),
        if (_unreadNotificationCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }


//-----------------------------AppBar-------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'Blur App',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: _buildNotificationIcon(),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ).then((_) {
                setState(() {
                  _unreadNotificationCount = 0;
                });
              });
            },
          ),
        ],
      ),

//-----------------------------Appdrawer-------------------------

      drawer: AppDrawer(
        onPageChanged: widget.onPageChanged,
      ),
      body: widget.body,
      floatingActionButton: widget.onFabPressed != null
          ? FloatingActionButton(
              onPressed: widget.onFabPressed,
              backgroundColor: widget.fabColor ?? Colors.orange[700],
              foregroundColor: Colors.white,
              elevation: 8,
              shape: const CircleBorder(),
              child: Icon(widget.fabIcon ?? Icons.build, size: 28),
              tooltip: 'แจ้งซ่อม',
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),

//-----------------------------BottomNavigationBar-------------------------

          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'หน้าแรก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'รายการ',
              ),
            ],
            currentIndex: widget.currentIndex == 2 ? 1 : widget.currentIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: widget.onTabSelected,
          ),
        ),
      ),
    );
  }
}
