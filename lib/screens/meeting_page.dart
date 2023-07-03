import 'package:flutter/material.dart';
import 'package:phase_1_app/screens/doctor_info.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { pending, completed }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.pending;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [
    {
      "doctor_name": "Mohamed Azmy",
      "doctor_profile": "assets/doctor_image5.jpg",
      "category": "Diabetology",
      "status": FilterStatus.pending
    },
    {
      "doctor_name": "Ahmed Ibrahim",
      "doctor_profile": "assets/doctor_image2.jpg",
      "category": "Nutritionist",
      "status": FilterStatus.pending
    },
    {
      "doctor_name": "Mahmoud Kholy",
      "doctor_profile": "assets/doctor_image3.jpg",
      "category": "Cardiology",
      "status": FilterStatus.completed
    },
    {
      "doctor_name": "Amr Mourad",
      "doctor_profile": "assets/doctor_image4.jpg",
      "category": "General",
      "status": FilterStatus.completed
    }
  ];

  @override
  Widget build(BuildContext context) {
    //in this appointment page
    //there are 2 cases either completed, pending
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'Pending':
          schedule['status'] = FilterStatus.pending;
          break;
        case 'Completed':
          schedule['status'] = FilterStatus.completed;
          break;
      }
      return schedule['status'] == status;
    }).toList();

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Appointment Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (FilterStatus filterStatus in FilterStatus.values)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (filterStatus == FilterStatus.pending) {
                                status = FilterStatus.pending;
                                _alignment = Alignment.centerLeft;
                              } else if (filterStatus ==
                                  FilterStatus.completed) {
                                status = FilterStatus.completed;
                                _alignment = Alignment.centerRight;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: status == filterStatus
                                  ? Config.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                filterStatus == FilterStatus.pending
                                    ? 'Pending'
                                    : 'Completed',
                                style: TextStyle(
                                  color: status == filterStatus
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Config.spaceSmall,
          Expanded(
            child: ListView.builder(
              itemCount: filteredSchedules.length,
              itemBuilder: (context, index) {
                var _schedule = filteredSchedules[index];
                bool isLastElement = filteredSchedules.length - 1 == index;
                return Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: !isLastElement
                      ? const EdgeInsets.only(bottom: 20)
                      : EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(_schedule['doctor_profile']),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _schedule['doctor_name'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _schedule['category'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (_schedule['status'] != FilterStatus.completed)
                          ScheduleCard(),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    schedules.remove(_schedule);
                                  });
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Config.primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            if (_schedule['status'] != FilterStatus.completed)
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Config.primaryColor),
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now().add(Duration(days: 14)),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _schedule['date'] = picked;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Reschedule Request'),
                                          content: Text(
                                              'Your Reschedule Request has been sent Successfully!'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text(
                                  'Replan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetails(
                                        doctorName: _schedule['doctor_name'],
                                        doctorImage:
                                            _schedule['doctor_profile'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Details',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class ScheduleCard extends StatefulWidget {
  ScheduleCard({Key? key}) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  DateTime date =
      DateTime.now().add(Duration(days: 14)); // date two weeks from now

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy').format(date);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            formattedDate,
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
        ],
      ),
    );
  }
}
