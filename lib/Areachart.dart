import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'ChildrenPage.dart';
import 'dart:math';
import 'TableVaccine.dart';  // Import dart:math for exponential function
import 'Pagesett.dart';

class GrowthChartScreen extends StatefulWidget {
  @override
  _GrowthChartScreenState createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends State<GrowthChartScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    CalendarBarApp(),  // Home Page
    Placeholder(),  // Placeholder for Chart Page
    ChildrenPage(),  // Children Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กราฟอ้างอิงการเจริญเติบโต',
            style: TextStyle(fontSize: 15)),
        backgroundColor: Colors.greenAccent,
      ),
      body: _selectedIndex == 1
          ? _buildChart(context)  // Call _buildChart if "กราฟ" is selected
          : _widgetOptions.elementAt(_selectedIndex),  // Otherwise, load from _widgetOptions
    );
  }

  Widget _buildChart(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,  // Adjust height for proper fit
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          minimum: 85,
          maximum: 140,
          interval: 5,
          majorTickLines: MajorTickLines(size: 0),
          title: AxisTitle(text: 'Height (cm)'),
        ),
        primaryYAxis: NumericAxis(
          minimum: 9,
          maximum: 50,
          interval: 5,
          majorTickLines: MajorTickLines(size: 0),
          title: AxisTitle(text: 'Weight (kg)'),
        ),
        title: ChartTitle(text: 'กราฟอ้างอิงการเจริญเติบโตอายุ 1-5 ปี'),
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
            widget: Container(
              child: Text('ผอม',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 137,
            y: 12,
          ),
          CartesianChartAnnotation(
            widget: Container(
              child: Text('ค่อนข้างผอม',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 130,
            y: 23,
          ),
          CartesianChartAnnotation(
            widget: Container(
              child: Text('เริ่มผอม',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 137,
            y: 22,
          ),
          CartesianChartAnnotation(
            widget: Container(
              child: Text('ปกติ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 115,
            y: 40,
          ),
          CartesianChartAnnotation(
            widget: Container(
              child: Text('เริ่มอ้วน',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 100,
            y: 45,
          ),
          CartesianChartAnnotation(
            widget: Container(
              child: Text('อ้วน',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            coordinateUnit: CoordinateUnit.point,
            x: 135,
            y: 45,
          ),
        ],
        series: <ChartSeries<_ChartData, double>>[
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getUnderweightData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'ผอม',
            color: Colors.orange.withOpacity(0.5),
            borderColor: Colors.orange,
            borderWidth: 2,
          ),
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getBelowNormalData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'เริ่มผอม',
            color: Colors.yellow.withOpacity(0.5),
            borderColor: Colors.yellow,
            borderWidth: 2,
          ),
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getlittleweightData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'ค่อนข้างผอม',
            color: Colors.blue.withOpacity(0.5),
            borderColor: Colors.blue,
            borderWidth: 2,
          ),
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getNormalData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'ปกติ',
            color: Colors.green.withOpacity(0.5),
            borderColor: Colors.green,
            borderWidth: 2,
          ),
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getAboveNormalData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'เริ่มอ้วน',
            color: Colors.blue.withOpacity(0.5),
            borderColor: Colors.blue,
            borderWidth: 2,
          ),
          SplineAreaSeries<_ChartData, double>(
            dataSource: _getOverweightData(),
            xValueMapper: (_ChartData data, _) => data.height,
            yValueMapper: (_ChartData data, _) => data.weight,
            name: 'อ้วน',
            color: Colors.purple.withOpacity(0.5),
            borderColor: Colors.purple,
            borderWidth: 2,
          ),
        ],
      ),
    );
  }

  List<_ChartData> _getUnderweightData() {
    List<_ChartData> data = [];
    double maxHeight = 140;  // จุดสิ้นสุดของส่วนสูง
    double maxWeight = 26.5; // น้ำหนักที่จุดสูงสุด
    double minWeight = 10;   // น้ำหนักเริ่มต้นที่ส่วนสูง 85 cm

    // คำนวณค่าพารามิเตอร์ B ใหม่เพื่อให้กราฟสิ้นสุดที่ 26.5 กิโลกรัมที่ 140 เซนติเมตร
    double B = -log((maxWeight - minWeight) / maxWeight) / (maxHeight - 85);

    // กำหนดสมการ exponential โดยให้มี positive slope
    for (double height = 85; height <= maxHeight; height += 5) {
      double weight = minWeight + (maxWeight - minWeight) * (1 - exp(-B * (height - 85)));
      data.add(_ChartData(height, weight));
    }

    return data;
  }



  List<_ChartData> _getlittleweightData() {
    List<_ChartData> data = [];
    for (double height = 85; height <= 140; height += 5) {
      double weight = 10.25 * exp(0.02 * (height - 85));  // Reduced initial multiplier
      data.add(_ChartData(height, weight));
    }
    return data;
  }

  List<_ChartData> _getBelowNormalData() {
    List<_ChartData> data = [];
    for (double height = 85; height <= 140; height += 5) {
      double weight = 11 * exp(0.02 * (height - 85));  // Slightly reduced initial multiplier
      data.add(_ChartData(height, weight));
    }
    return data;
  }

  List<_ChartData> _getNormalData() {
    List<_ChartData> data = [];
    for (double height = 85; height <= 140; height += 5) {
      double weight = 14 * exp(0.02 * (height - 85));  // Kept as a baseline
      data.add(_ChartData(height, weight));
    }
    return data;
  }

  List<_ChartData> _getAboveNormalData() {
    List<_ChartData> data = [];
    for (double height = 85; height <= 140; height += 5) {
      double weight = 18 * exp(0.02 * (height - 85));  // Reduced initial multiplier
      data.add(_ChartData(height, weight));
    }
    return data;
  }

  List<_ChartData> _getOverweightData() {
    List<_ChartData> data = [];
    for (double height = 85; height <= 140; height += 5) {
      double weight = 150  * exp(-0.02 * (height - 85));  // Adjusted for negative Y-intercept
      data.add(_ChartData(height, weight));
    }
    return data;
  }

}

class _ChartData {
  _ChartData(this.height, this.weight);

  final double height;
  final double weight;
}
