import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';
import 'package:spark/Pages/Calendar/expandable_fab.dart';
import 'package:spark/Pages/Calendar/time_table.dart';
import 'calendar_card.dart';
import 'event_list.dart';
import 'events_model.dart';
import 'event_manipulate.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late StreamController<String> _streamController;
  List<dynamic> events = [];
  final logger = Logger();
  int _selectedIndex = 0;
  final List<String> _options = [
    'All',
    'Assignment Submission',
    'Extra Class',
    'Others'
  ];
  late Realm realm;
  bool _isLoading = false;
  final GlobalKey _menuKey = GlobalKey();
  String _selectedDate = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _streamController.stream.listen((date) {
      setState(() {
        _selectedDate = date;
      });
      fetchEvents(date, _selectedIndex);
    });
    final config2 =
        Configuration.local([Event.schema, Schedule.schema], schemaVersion: 5);

    realm = Realm(config2);
    fetchEvents(DateTime.now().toString(), _selectedIndex);
  }

  @override
  void dispose() {
    _streamController.close();
    realm.close();
    super.dispose();
  }

  String getDayofWeek(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE').format(dateTime);
  }

  Future<void> fetchEvents(String selectedDate, int selectedIndex) async {
    setState(() {
      _isLoading = true;
    });
    logger.d(
        'Fetching events for date: $selectedDate with filter index: $selectedIndex');

    try {
      DateTime dateTime = DateTime.parse(selectedDate);
      String date = DateFormat('yyyy-MM-dd').format(dateTime);
      String day = getDayofWeek(date);

      var fetchedEvents = <dynamic>[];

      if (_selectedIndex == 0) {
        fetchedEvents.addAll(realm.all<Event>().where((event) {
          logger.d(
              'Event found: ${event.id}, date: ${DateFormat('yyyy-MM-dd').format(event.eventDate)}, SubjectName: ${event.subjectName}');
          return DateFormat('yyyy-MM-dd').format(event.eventDate) == date;
        }));
        fetchedEvents.addAll(
            realm.all<Schedule>().where((schedule) => schedule.day == day));
      } else {
        fetchedEvents.addAll(realm.all<Event>().where((event) =>
            DateFormat('yyyy-MM-dd').format(event.eventDate) == date &&
            event.eventType == _options[_selectedIndex]));
        fetchedEvents.addAll(realm.all<Schedule>().where((schedule) =>
            schedule.day == day &&
            schedule.eventType == _options[_selectedIndex]));
      }
      logger.d('Fetched events: ${fetchedEvents.length}');

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      logger.e('Error fetching events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFilterSelected(int index, String selectedDate) {
    setState(() {
      _selectedIndex = index;
      fetchEvents(selectedDate, _selectedIndex);
    });
  }

  void _refreshEvents() {
    fetchEvents(_selectedDate, _selectedIndex);
  }

  Widget _buildFilterButton() {
    return IconButton(
      key: _menuKey,
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        final RenderBox button =
            _menuKey.currentContext!.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          context: context,
          position: position,
          items: _options.asMap().entries.map((entry) {
            int idx = entry.key;
            String option = entry.value;
            return PopupMenuItem<int>(
              value: idx,
              child: Text(option),
            );
          }).toList(),
        ).then((value) {
          if (value != null) {
            _onFilterSelected(value, _selectedDate);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'C A L E N D A R',
            style: TextStyle(
                fontSize: 24,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            CalendarCard(streamController: _streamController),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Schedule",
                      style:
                          TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
                  _buildFilterButton(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : events.isEmpty
                    ? const Column(
                        children: [
                          SizedBox(height: 20),
                          Center(
                              child:
                                  Text("You don't have anything right now.")),
                        ],
                      )
                    : EventList(
                        events: events,
                        realm: realm,
                        onDelete: (String id) {
                          setState(() {
                            _deleteEvent(id);
                            _refreshEvents();
                          });
                        },
                        onEdit: () {
                          setState(() {
                            _refreshEvents();
                          });
                        })
          ],
        ),
        floatingActionButton: ExpandableFab(distance: 80, children: [
          AddEventFab(realm: realm, onEventAdded: _refreshEvents),
          AddTimeTable(realm: realm, onScheduleUpdated: _refreshEvents)
        ]));
  }

  void _deleteEvent(String id) {
    // Try to find and delete the event in the Event collection
    final event = realm.find<Event>(id);
    if (event != null) {
      logger.d("Event found: $id. Deleting...");
      realm.write(() {
        realm.delete(event);
      });
      logger.d("Event deleted from Event collection: $id");
    } else {
      logger.w("Event with id $id not found in Event collection");
    }

    // Try to find and delete the event in the Schedule collection
    final schedule = realm.find<Schedule>(id);
    if (schedule != null) {
      logger.d("Schedule found: $id. Deleting...");
      realm.write(() {
        realm.delete(schedule);
      });
      logger.d("Event deleted from Schedule collection: $id");
    } else {
      logger.w("Event with id $id not found in Schedule collection");
    }

    // Refresh events after deletion
    _refreshEvents();
  }
}

