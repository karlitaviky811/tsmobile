import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/menuBottom/tabs_page.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool showEvents = true;
  List<NeatCleanCalendarEvent> _eventList = [];

  @override
  void initState() {
    super.initState();
    // Cargar eventos del servicio al iniciar
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final serviceVisit = VisitService();
      List<NeatCleanCalendarEvent> events =
          await serviceVisit.fetchTechnicalVisits();
      setState(() {
        _eventList = events;
      });
    } catch (e) {
      print('Error al cargar eventos: $e');
    }
  }

  Widget eventCell(BuildContext context, NeatCleanCalendarEvent event,
      String start, String end) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Text('Calendar Event: ${event.summary} from $start to $end'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario', style: AppStyle.txtPoppinsRegular18Black),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TabsPage()),
              );
            }),
      ),
      body: SafeArea(
        child: Calendar(
          locale: 'es_ES',
          startOnMonday: true,
          weekDays: const ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'],
          eventsList: _eventList,
          isExpandable: true,
          // You can set your own event cell builder function to customize the event cells
          // Try it by uncommenting the line below
          // eventCellBuilder: eventCell,
          eventDoneColor: Colors.deepPurple,
          selectedColor: Colors.grey,
          selectedTodayColor: Colors.blue,
          todayColor: Colors.teal,
          defaultDayColor: Colors.black,
          defaultOutOfMonthDayColor: Colors.grey,
          datePickerDarkTheme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.black45,
              onPrimary: Colors.yellow,
              surface: Colors.grey,
              onSurface: Colors.yellow,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          datePickerLightTheme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.grey,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.teal,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          eventColor: null,
          todayButtonText: '',
          allDayEventText: '',
          multiDayEndText: 'Ende',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          onEventSelected: (value) {
            print('Event selected ${value.summary}');
          },
          onEventLongPressed: (value) {
            print('Event long pressed ${value.summary}');
          },
          onDateSelected: (value) {
            print('Date selected $value');
          },
          onRangeSelected: (value) {
            print('Range selected ${value.from} - ${value.to}');
          },
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          showEventListViewIcon: true,
          showEvents: showEvents,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showEvents = !showEvents;
          });
        },
        child: Icon(showEvents ? Icons.visibility_off : Icons.visibility),
        backgroundColor: Colors.white,
      ),
    );
  }
}
