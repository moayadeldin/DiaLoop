import 'package:flutter/material.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class UBDPage extends StatefulWidget {
  const UBDPage({super.key});

  @override
  State<UBDPage> createState() => _UBDPageState();
}

class _UBDPageState extends State<UBDPage> {
  final TextEditingController tddController =
      TextEditingController(text: 'TDD');
  final TextEditingController wtController = TextEditingController(text: 'WT');
  final TextEditingController tbgController =
      TextEditingController(text: 'TBG');

  double latestUBD = 0.0; // Variable to store the latest UBD reading
  double LIT = 0;
  DateTime? lastUBDUpdate; // Timestamp of the last UBD update

  String? selectedActivity;
  String? selectedMeal;
  final Map<String, int> activityValues = {
    'Sleeping': 6,
    'Slow Walking': 8,
    'Light Yoga': 10,
    'Casual Cycling': 12,
    'Jogging': 14,
    'Running': 16,
    'Training': 18,
    'Weightlifting': 20
  };
  final Map<String, int> mealValues = {
    'Rice': 53,
    'Pasta': 40,
    'Fruit Salad': 25,
  };

  Future<int> _fetchLatestCBG() async {
    try {
      var url = "http://10.0.2.2:5000/random_number";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['concentration_reading'] != null &&
            data['concentration_reading'] is int) {
          return data['concentration_reading']; // Return the CBG value
        } else {
          return 0; // Set a default value if the value is null or not an integer
        }
      } else {
        return 0; // Set to 0 in case of a non-200 response
      }
    } catch (e) {
      print('Error: $e');
      return 0; // Set to 0 in case of an exception
    }
  }

  // Method to show the popup for LIT value input
  Future<void> _showLITPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter LIT Value For the First Time'),
          content: TextField(
            onChanged: (value) {
              // You can use this value to update LIT
              LIT = double.tryParse(value) ?? 0.0;
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: "Enter LIT value"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                // Close the dialog and proceed with calculations
                Navigator.of(context).pop();
                _calculateAndShowUBD(); // Recalculate with new LIT value
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLatestUBDPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter latest UBD Value'),
          content: TextField(
            onChanged: (value) {
              latestUBD = double.tryParse(value) ?? 0.0;
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: "Enter latest UBD value"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _calculateAndShowUBD(); // Recalculate with new latestUBD value
              },
            ),
          ],
        );
      },
    );
  }

  void _sendUBDToESP32(int ubd) async {
    try {
      var url = Uri.parse('http://10.112.224.57/data'); // ESP32 IP Address
      var response = await http.post(url, body: 'UBD Value: $ubd');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error sending UBD to ESP32: $e');
    }
  }

  void _calculateAndShowUBD() async {
    final int CBG = await _fetchLatestCBG();
    // Fetch the latest CBG reading
    print(CBG);

    if (LIT == 0) {
      await _showLITPopup();
      return; // Return here to stop further execution until LIT is updated
    }

    if (latestUBD == 0.0) {
      await _showLatestUBDPopup();
      return; // Return here to stop further execution until latestUBD is updated
    }

    if (selectedMeal == null) {
      // Show error or handle the case when meal selection is not made
      return;
    }

    final double tdd = double.tryParse(tddController.text) ?? 0;
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double valueOfMeal = mealValues[selectedMeal]!.toDouble();
    final double AM = (activityValues[selectedActivity] ?? 0) / 10;

    final double icAverage = ((500 / tdd) + (850 / wt)) / 2;

    final double fd = valueOfMeal / icAverage;

    final double SF = 1700 / tdd;

    final double TBG = double.tryParse(tbgController.text) ?? 0;

    final double CD = (CBG - TBG) / SF;

    print(icAverage);

    print('FD value: $fd');

    print('CD value: $CD');

    // Update LIT (Last Insulin Time) based on the last UBD update
    if (lastUBDUpdate != null) {
      final Duration timeDifference = DateTime.now().difference(lastUBDUpdate!);
      LIT = timeDifference.inHours.toDouble();
    }

    // Calculate IOB (Insulin On Board)
    final double iob = latestUBD * (1 - LIT / 5) * 0.2;

    // Calculate UBD
    final double ubd = (fd + CD - iob) * AM;

    print('LIT Value $LIT');
    print('latestUBD  $latestUBD');
    print('Glucose Reading $CBG');
    print('IOB $iob');

    // Update the latest UBD reading
    latestUBD = ubd;
    lastUBDUpdate = DateTime.now();

    // Display UBD to user and handle confirmation
    _showUBDConfirmationDialog(ubd.round());
  }

  void _showUBDConfirmationDialog(int ubd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('UBD Confirmation'),
          content: Text(
              'Your UBD is $ubd, do you want to confirm this dosage as your next insulin dosage?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _sendUBDToESP32(ubd); // Send UBD to ESP32
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
              style: TextButton.styleFrom(
                primary: Colors.green, // Text color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Reconsider'),
              style: TextButton.styleFrom(
                primary: Colors.red, // Text color
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UBD Calculation'),
        backgroundColor: Config.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildInputField(tddController),
                _buildInputField(wtController),
                _buildDropdownField(
                    activityValues, selectedActivity, 'Select Activity',
                    (newValue) {
                  setState(() {
                    selectedActivity = newValue;
                  });
                }),
                _buildDropdownField(mealValues, selectedMeal, 'Select Meal',
                    (newValue) {
                  setState(() {
                    selectedMeal = newValue;
                  });
                }),
                _buildInputField(tbgController),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAndShowUBD,
              child: const Text('Proceed'),
              style: ElevatedButton.styleFrom(
                primary: Config.primaryColor,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter value',
      ),
    );
  }

  Widget _buildDropdownField(Map<String, int> values, String? selectedValue,
      String labelText, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      items: values.keys.map((String key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(key),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    tddController.dispose();
    wtController.dispose();
    tbgController.dispose();
    super.dispose();
  }
}
