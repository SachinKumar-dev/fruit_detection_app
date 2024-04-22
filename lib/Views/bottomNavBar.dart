import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruit_detection_app/Ui_Helper/colorHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomePage.dart';
import 'UserProfilePage.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex > 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: const [
              HomePage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: lightGreen,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
