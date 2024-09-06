import 'package:customchart/Areachart.dart';
import 'package:flutter/material.dart';
import 'package:customchart/Add_Edit_DeleteChilde.dart';
import 'package:customchart/Pagesett.dart';
import 'ChildrenPage.dart';
import 'TableVaccine.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โภชนาการสำหรับเด็กอายุ 1-5 ปี',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildGridTile(
              context,
              'assets/vaccine.jpg',
              'นัดฉีดวัคซีน',
              CalendarBarApp(),
            ),
            _buildGridTile(
              context,
              'assets/bg.jpg',
              'บันทึกข้อมูลเด็ก',
              AddChildrenPage(),
            ),
            _buildGridTile(
              context,
              'assets/pngegg.png',
              'ข้อมูลเด็ก',
              ChildrenPage(),
            ),
            _buildGridTile(
              context,
              'assets/bg.jpg',
              'กราฟการเจริญเติบโต',
              GrowthChartScreen(),
            ),
            _buildGridTile(
              context,
              'assets/bg.jpg',
              'Setting',
              SettingsPage(),
            ),
            // Add more tiles as needed
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(
      BuildContext context, String imagePath, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
