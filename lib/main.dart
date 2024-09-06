import 'package:customchart/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:customchart/Services/Database_Helper.dart';
import 'package:customchart/LoginPage/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Areachart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), // Set VaccinePage as the home page
    );
  }
}

class VaccinePage extends StatefulWidget {
  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _addVaccineNameController =
  TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<Map<String, dynamic>> _vaccines = [];

  @override
  void initState() {
    super.initState();
    _fetchVaccines();
  }

  Future<void> _fetchVaccines() async {
    final vaccines = await _dbHelper.getVaccines();
    setState(() {
      _vaccines = vaccines;
    });
  }

  Future<void> _addVaccine() async {
    if (_vaccineNameController.text.isNotEmpty &&
        _addVaccineNameController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      await _dbHelper.insertVaccine({
        'vaccineName': _vaccineNameController.text,
        'addVaccineName': _addVaccineNameController.text,
        'date': _dateController.text,
        'time': _timeController.text,
      });
      _vaccineNameController.clear();
      _addVaccineNameController.clear();
      _dateController.clear();
      _timeController.clear();
      _fetchVaccines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการฉีดวัคซีน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vaccineNameController,
              decoration: InputDecoration(labelText: 'ชื่อวัคซีน'),
            ),
            TextField(
              controller: _addVaccineNameController,
              decoration: InputDecoration(labelText: 'ชื่อวัคซีนเพิ่มเติม'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'วันที่'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'เวลา'),
            ),
            ElevatedButton(
              onPressed: _addVaccine,
              child: Text('Add Vaccine'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _vaccines.length,
                itemBuilder: (context, index) {
                  final vaccine = _vaccines[index];
                  return ListTile(
                    title: Text(vaccine['vaccineName']),
                    subtitle: Text(
                        '${vaccine['addVaccineName']} - ${vaccine['date']} ${vaccine['time']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SettingsList(),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Account Info'),
          leading: Icon(Icons.account_circle),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );*/
          },
        ),
        ListTile(
          title: Text('Notifications'),
          leading: Icon(Icons.notifications),
          trailing: Switch(
            value: true, // This should be linked to your notification settings
            onChanged: (value) {
              // Update notification settings
            },
          ),
        ),
        ListTile(
          title: Text('Theme'),
          leading: Icon(Icons.brightness_6),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to Theme settings
          },
        ),
        ListTile(
          title: Text('Log out'),
          leading: Icon(Icons.logout),
          onTap: () {
            _dialogBuilder(context);
          },
        ),
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log out'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}