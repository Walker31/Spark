import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../Providers/attendance_provider.dart';
import 'attendance_utils.dart'; // Import the utilities

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'A T T E N D A N C E',
          style: TextStyle(
              color: Colors.blueGrey,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.blueGrey,
              size: 30,
            ),
            onPressed: () {
              Provider.of<AttendanceProvider>(context, listen: false)
                  .fetchSubjects();
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addButton',
            onPressed: () {
              navigateToItemEntry(context);
            },
            tooltip: 'Add New Subject',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'searchButton',
            onPressed: () {
              search(context);
            },
            tooltip: 'Search Attendance',
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final Logger logger = Logger();

    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, child) {
        if (attendanceProvider.subjects.isEmpty) {
          return const Center(
              child: Text(
            'No Subjects added Yet',
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontFamily: 'Caveat'),
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: attendanceProvider.subjects.length,
              itemBuilder: (context, index) {
                final subject = attendanceProvider.subjects[index];
                logger.d(
                    'Subject $index: Name - ${subject.subName}, Code - ${subject.subCode}, Present - ${subject.nPresent}, Total - ${subject.nTotal}, Percent - ${subject.percent}');
                return Card(
                  elevation: 6,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => onItemTapped(context, subject),
                    onLongPress: () => deleteSubject(context, subject),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.subName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 33.0,
                                    fontFamily: 'Caveat',
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subject.subCode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 5,
                                color:
                                    getPercentageColor(subject.percent.toInt()),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${subject.percent.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
