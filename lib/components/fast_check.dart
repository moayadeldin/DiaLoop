import 'package:flutter/material.dart';
import 'package:phase_1_app/utils/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:phase_1_app/utils/config.dart';

class FastCheckPage extends StatefulWidget {
  const FastCheckPage({Key? key}) : super(key: key);

  @override
  _FastCheckPageState createState() => _FastCheckPageState();
}

class _FastCheckPageState extends State<FastCheckPage> {
  final _formKey = GlobalKey<FormState>();
  var result = 0;
  String predictionResult = "";
  Color predictionColor = Colors.black;

  final rowSpacer = TableRow(children: [
    SizedBox(
      height: 10,
    ),
    SizedBox(
      height: 10,
    ),
    SizedBox(
      height: 10,
    )
  ]);

  final List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          9, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Check'),
        backgroundColor: Config.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Table(
                    defaultColumnWidth:
                        FlexColumnWidth(), // Distribute space equally
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          _buildTableRow("Age", controller: controllers[0]),
                          _buildTableRow("BGL", controller: controllers[1]),
                          _buildTableRow("DBP", controller: controllers[2]),
                        ],
                      ),
                      rowSpacer,
                      TableRow(
                        children: [
                          _buildTableRow("SBP", controller: controllers[3]),
                          _buildTableRow("Heart Rate",
                              controller: controllers[4]),
                          _buildTableRow("Temperature",
                              controller: controllers[5]),
                        ],
                      ),
                      rowSpacer,
                      TableRow(
                        children: [
                          _buildTableRow("SPO2", controller: controllers[6]),
                          _buildTableRow("Sweating",
                              controller: controllers[7]),
                          _buildTableRow("Shivering",
                              controller: controllers[8]),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      List<double> inputValues = controllers.map((controller) {
                        return double.parse(controller.text);
                      }).toList();

                      var url =
                          'http://10.112.228.18:5001/predict'; // URL to your Flask server to be updated according to IP address
                      var response = await http.post(
                        Uri.parse(url),
                        headers: {"Content-Type": "application/json"},
                        body: json.encode({'input': inputValues}),
                      );

                      if (response.statusCode == 200) {
                        var result = jsonDecode(response.body)['prediction'];

                        if (result < 0.5) {
                          predictionResult =
                              'Your current results suggest the case is Non Diabetic';
                          predictionColor = Colors.green;
                        } else if (result < 0.8) {
                          predictionResult =
                              'Your current results suggest a potential case of being Diabetic, follow with your caretaker';
                          predictionColor = Colors.yellow;
                        } else {
                          predictionResult =
                              'Your current results suggest your case most probably as Diabetic, you need to receive a proper treatment';
                          predictionColor = Colors.red;
                        }

                        setState(() {
                          print('The result is, $result');
                        });
                      } else {
                        // If server returns a non-200 response
                        print(
                            'Server error. HTTP status: ${response.statusCode}');
                      }
                    }
                  },
                  child: Text('Predict'),
                  style: ElevatedButton.styleFrom(primary: Config.primaryColor),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: predictionResult,
                      style: TextStyle(fontSize: 20, color: predictionColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(String label1,
      {TextEditingController? controller, bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label1, style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 50,
          child: Center(
            child: TextFormField(
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}
