import 'package:flutter/material.dart';
import 'package:phase_1_app/components/meeting_screen.dart';
import 'package:phase_1_app/components/graph.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": 'Diabetology',
    },
    {
      "icon": FontAwesomeIcons.bowlFood,
      "category": 'Nutrition and Dietetics',
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": 'Cardiology',
    },
    {
      "icon": FontAwesomeIcons.brain,
      "category": 'Psychiarity',
    }
  ];
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello, User!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/mypic.jpg'),
                      ),
                    )
                  ],
                ),
                Config.spaceMedium,
                LineChartWidget(),
                Config.spaceSmall,
                const Text(
                  '  Follow with your Caretaker',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Config.spaceSmall,
                AppointmentCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
