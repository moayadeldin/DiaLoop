import 'package:flutter/material.dart';
import 'package:phase_1_app/components/fast_check.dart';
import 'package:phase_1_app/data/data.dart';
import 'package:phase_1_app/screens/groups.dart';
import 'package:phase_1_app/screens/meals.dart';
import 'package:phase_1_app/screens/tabs.dart';
import 'package:phase_1_app/screens/ubd.dart';
import 'package:phase_1_app/utils/text.dart';
import '../screens/meeting_page.dart';
import '../screens/home.dart';
import '../utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  //variable declaration
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          HomePage(),
          AppointmentPage(),
          FastCheckPage(),
          const TabsScreen(),
          UBDPage(), // Assuming you have a UBDPage
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.arrowUp),
            label: 'Fast Check',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.pizzaSlice),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            // Choose an appropriate icon for UBD, like capsules or prescription bottle
            icon: FaIcon(FontAwesomeIcons.capsules),
            label: 'UBD',
          ),
        ],
      ),
    );
  }
}
