import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/**
 * 右上にアイコンを追加。今日に移動できます
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Calendar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  final CalendarController _calendarController = CalendarController();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calendarController.displayDate = _selectedDate;
      });
    }
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _calendarController.displayDate = _selectedDate;
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today, color: Colors.black),
            onPressed: _goToToday,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '👤',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        controller: _calendarController,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.header) {
            _selectDate(context);
          } else if (details.targetElement == CalendarElement.viewHeader ||
              details.targetElement == CalendarElement.calendarCell) {
            setState(() {
              _calendarController.view = CalendarView.day;
              _calendarController.displayDate = details.date;
            });
          }
        },
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
      'Conference',
      startTime,
      endTime,
      const Color(0xFF0F8644),
      false,
    ));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
