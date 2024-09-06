import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:customchart/event.dart';
import 'package:customchart/Services/Database_Helper.dart';

class CalendarBarApp extends StatelessWidget {
  const CalendarBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const CalendarExample(),
    );
  }
}

class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadVaccineEvents();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _loadVaccineEvents() async {
    final vaccines = await _dbHelper.getVaccines();
    setState(() {
      for (var vaccine in vaccines) {
        final date = DateTime.parse(vaccine['date']);
        final time = vaccine['time'];
        final vaccineName = vaccine['vaccineType'];
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(Event('$vaccineName @ $time'));
      }
    });
  }

  Future<void> _addEvent(Map<String, dynamic> newEvent) async {
    final date = DateTime.parse(newEvent['date']);
    final time = newEvent['time'];
    final vaccineType = newEvent['vaccineType'];

    setState(() {
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(Event('$vaccineType @ $time'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางวัคซีน'),
        backgroundColor: Colors.greenAccent,  // Set app bar color to green
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2025, 1, 1),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: Colors.red[600]),
                    holidayTextStyle: TextStyle(color: Colors.red[600]),
                    selectedDecoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayTextStyle: TextStyle(color: Colors.white),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                    cellMargin: EdgeInsets.all(5),
                    defaultTextStyle: TextStyle(
                      backgroundColor: Colors.white30,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.red[600]),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty)
                      Container(
                        margin: EdgeInsets.all(20),
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ชื่อวัคซีน')),
                            DataColumn(label: Text('เวลา')),
                          ],
                          rows: _getEventsForDay(_selectedDay!).map((event) {
                            final splitEvent = event.title.split(' @ ');
                            return DataRow(cells: [
                              DataCell(Text(splitEvent[0])),
                              DataCell(Text(splitEvent[1])),
                            ]);
                          }).toList(),
                        ),
                      ),
                    if (_selectedDay != null && _getEventsForDay(_selectedDay!).isEmpty)
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('ไม่มีข้อมูลวัคซีนสำหรับวันนี้'),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VaccinePage(),
                    ),
                  );
                  if (result != null) {
                    _addEvent(result);
                  }
                },
                child: Icon(Icons.add),
                tooltip: 'เพิ่มชื่อวัคซีน',
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class VaccinePage extends StatefulWidget {
  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _VaccineTypeController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();

  TimeOfDay? _selectedTime;
  String? _vaccineType;
  List<Map<String, dynamic>> _vaccines = [];

  @override
  void dispose() {
    _VaccineTypeController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกเวลา')),
        );
        return;
      }

      Map<String, dynamic> child = {
        'vaccineType': _vaccineType,
        'time': '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        'date': DateTime.now().toIso8601String().split('T').first, // Save the current date
      };

      await _dbHelper.insertVaccine(child);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลแล้ว')),
      );

      Navigator.pop(context, child); // Return the inserted event to the previous page
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการฉีดวัคซีน'),
        backgroundColor: Colors.greenAccent,  // Set app bar color to green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'วัคซีน',
                ),
                items: <String>[
                  'วัคซีนอีสุกอีใส',
                  'วัคซีนโรคติดเชื้อไอ พี ดี',
                  'ไข้สมองอักเสบเจอี (LAJE1)',
                  'คอตีบ-บาดทะยัก-ไอกรน (DTP4)',
                  'โปลิโอชนิดหยอด (OPV4)',
                  'หัด-คางทูม-หัดเยอรมัน (MMR2)',
                  'คอตีบ-บาดทะยัก-ไอกรน (DTP5)',
                  'โปลิโอชนิดหยอด (OPV5)',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _vaccineType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกวัคซีน';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedTime == null
                    ? 'เวลา'
                    : 'เวลา: ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectTime(context),
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
