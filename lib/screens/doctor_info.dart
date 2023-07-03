import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phase_1_app/components/appbar.dart';
import 'package:phase_1_app/utils/config.dart';

class DoctorDetails extends StatefulWidget {
  final String doctorName;
  final String doctorImage;
  const DoctorDetails(
      {super.key, required this.doctorName, required this.doctorImage});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appTitle: widget.doctorName + '\'s Profile',
          icon: const FaIcon(Icons.arrow_back_ios),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              icon: FaIcon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_outline),
              color: Colors.red,
            ),
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            AboutDoctor(
                doctorName: widget.doctorName, doctorImage: widget.doctorImage),
            DetailBody(),
          ],
        )));
  }
}

class AboutDoctor extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  const AboutDoctor(
      {super.key, required this.doctorName, required this.doctorImage});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage(doctorImage),
          ),
          Config.spaceMedium,
          Text(
            doctorName,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Kasr Al-Ainy Faculty of Medicine. Harvard University, Massachusetts, United States.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Al-Salam General Hospital in Cairo',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Config.spaceSmall,
          const DoctorInfo(),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Row(
      children: [
        InfoCard(label: 'Patients', value: '222', icon: Icons.people),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
            label: 'Experience', value: '10 years', icon: Icons.calendar_today),
        const SizedBox(
          width: 15,
        ),
        InfoCard(label: 'Rating', value: '4.6', icon: Icons.star),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key,
      required this.label,
      required this.value,
      required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Config.primaryColor, // set border color
            width: 2, // set border width
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Config.primaryColor, // set icon color
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Config.primaryColor, // change text color
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
      ),
    );
  }
}
