import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:logger/logger.dart';
import 'package:spark/data/datesheet_data.dart';
import '../../database/subject_db.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  ScheduleState createState() => ScheduleState();
}

class ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isLoading = false;
  final bool _hasError = false;
  late Future<List<DateSheet>> items;
  late Future<List> subjects = SubjectDB().fetchSubjects();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchScheduleData('Monday');
  }

  void _handleTabSelection() {
    String dayName = _getDayName(_tabController.index);
    _fetchScheduleData(dayName);
  }

  String _getDayName(int index) {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'][index];
  }

  void _fetchScheduleData(String dayName) {
    items = SubjectDB().fetchDateSheetsByDay(dayName);
    setState(() {});
  }

  void _deleteClass(BuildContext context, String subName, String dayName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                    'Delete Class',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink, // Adjust the color as needed
                    ),
                  ),
            content: const Text('Are you sure you want to delete this subject?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  SubjectDB().deleteDateSheet(subName);
                  Navigator.of(context).pop();
                  _fetchScheduleData(
                      dayName); // Refresh the list after deleting a subject
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  Widget _buildDayPage(BuildContext context, String dayName, Color color) {
    return FutureBuilder<List<DateSheet>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              strokeWidth: 6.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<DateSheet> items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Text('No schedule available for $dayName.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DateSheet dateSheet = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    onLongPress: () => _deleteClass(
                        context, dateSheet.subName, dateSheet.day),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(8)),
                    ),
                    title: Text(
                      dateSheet.subName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${dateSheet.fromTime} -> ${dateSheet.toTime}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        // Add functionality to show more details
                      },
                    ),
                    // Add onTap to edit the schedule entry
                    onTap: () => _editClass(context, dateSheet),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  void _editClass(BuildContext context, DateSheet dateSheet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Class'),
          content: ScheduleEntryDialog(
            onAddSchedule: (day, subName, from, to) {
              // Implement the logic to update the existing entry
              Logger().i('Editing subject: $subName from $from to $to');
              SubjectDB().updateDateSheet(
                day,
                subName,
                from,
                to,
              );
              Navigator.pop(context); // Close the dialog
              _fetchScheduleData(day); // Refresh schedule data
            },
            initialData: dateSheet, // Pass the existing data to populate the form
          ),
        );
      },
    );
  }

  void _navigateToScheduleEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Schedule'),
          content: ScheduleEntryDialog(
            onAddSchedule: (day, subName, from, to) {
              Logger().i('Subject name: $subName from $from to $to');
              SubjectDB().create3(
                day: day,
                subName: subName,
                toTime: to,
                fromTime: from,
              ).then((_) {
                Navigator.pop(context); // Close the dialog
                _fetchScheduleData(day); // Refresh schedule data
              }).catchError((error) {
                Logger().e('Error adding subject: $error');
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink, // Change the color as needed
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                    Tab(text: 'Mon'),
                    Tab(text: 'Tue'),
                    Tab(text: 'Wed'),
                    Tab(text: 'Thu'),
                    Tab(text: 'Fri'),
                ],
              ),

          ),
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        _navigateToScheduleEntry(context);
      },
      backgroundColor: Colors.pink, // Change the background color
      splashColor: Colors.white, // Change the splash color
      elevation: 2, // Add some elevation for a shadow effect
      tooltip: 'Add Schedule',
      child: const Icon(Icons.add)
    ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Error fetching data. Please try again.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          String dayName =
                              _getDayName(_tabController.index);
                          _fetchScheduleData(dayName);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    String dayName =
                        _getDayName(_tabController.index);
                    try {
                      _fetchScheduleData(dayName);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error refreshing data: $e'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [ 
                      _buildDayPage(context, 'Monday', Colors.blue),
                      _buildDayPage(context, 'Tuesday', Colors.red),
                      _buildDayPage(context, 'Wednesday', Colors.green),
                      _buildDayPage(context, 'Thursday', Colors.orange),
                      _buildDayPage(context, 'Friday', Colors.purple),
                    ],
                  ),
                ),
    );
  }
}

class ScheduleEntryDialog extends StatefulWidget {
  final Function(String, String, String, String) onAddSchedule;
  final DateSheet? initialData; // Add this property

  const ScheduleEntryDialog({
    Key? key,
    required this.onAddSchedule,
    this.initialData, // Add this argument to the constructor
  }) : super(key: key);

  @override
  ScheduleEntryDialogState createState() => ScheduleEntryDialogState();
}

class ScheduleEntryDialogState extends State<ScheduleEntryDialog> {
  TextEditingController subName = TextEditingController();
  String? selectedDay;
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with existing data if available
    if (widget.initialData != null) {
      subName.text = widget.initialData!.subName;
      selectedDay = widget.initialData!.day;
      selectedFromTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.initialData!.fromTime),
      );
      selectedToTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.initialData!.toTime),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: subName,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        DropdownButtonFormField<String>(
          value: selectedDay,
          hint: const Text('Select Weekday'),
          onChanged: (newValue) {
            setState(() {
              selectedDay = newValue;
            });
          },
          items: <String>[
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      selectedFromTime = selectedTime;
                    });
                  }
                },
                child: TextFormField(
                  enabled: false,
                  controller: TextEditingController(
                    text: selectedFromTime != null
                        ? selectedFromTime!.format(context)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    labelText: 'From',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      selectedToTime = selectedTime;
                    });
                  }
                },
                child: TextFormField(
                  enabled: false,
                  controller: TextEditingController(
                    text: selectedToTime != null
                        ? selectedToTime!.format(context)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    labelText: 'To',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (selectedDay != null &&
                subName.text.isNotEmpty &&
                selectedFromTime != null &&
                selectedToTime != null) {
              widget.onAddSchedule(
                selectedDay!,
                subName.text,
                selectedFromTime!.format(context),
                selectedToTime!.format(context),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all fields.'),
                ),
              );
            }
          },
          child: const Text('Add Subject'),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Schedule(),
  ));
}
