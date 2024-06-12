import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../Boxes/attendance_count.dart';
import '../../Boxes/subject.dart';

class History extends StatelessWidget {
  final Subject item;
  const History({super.key, required this.item});
  final String backgroundImagePath = 'assets/background_image.jpeg';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "History",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 15,
      ),
      body: Stack(children: [
        Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                color: Colors.black
                .withOpacity(0.6), // Adjust opacity for better readability
                colorBlendMode: BlendMode.darken),
        HistoryList(item: item)
        ]),
    );
  }
}

class HistoryList extends StatefulWidget {
  final Subject item;

  const HistoryList({super.key, required this.item});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<HistoryList> {
  late Subject item;
  late Future<List<AttendanceCount>>? items;
  final Logger logger = Logger();
  final String backgroundImagePath = 'assets/background_image.jpeg';


  @override
  void initState() {
    super.initState();
    item = widget.item;
    fetchList(item.subName);
  }

  void fetchList(String subName) {
    items = fetchHistory(subName);
    setState(() {});
  }

  Future<List<AttendanceCount>> fetchHistory(String subName) async {
    try {
      final attendanceBox = await Hive.openBox('attendanceBox');
      final historyList = attendanceBox.values
          .where((attendance) => attendance.subName == subName)
          .toList()
          .cast<AttendanceCount>();
      return historyList;
    } catch (e) {
      logger.e("Error fetching history: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                color: Colors.black
                .withOpacity(0.6), // Adjust opacity for better readability
                colorBlendMode: BlendMode.darken),
          FutureBuilder<List<AttendanceCount>>(
          future: items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No history available for ${item.subName}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              );
            } else {
              List<AttendanceCount> historyList = snapshot.data!;
              return ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  AttendanceCount historyItem = historyList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      tileColor: const Color.fromARGB(255, 151, 27, 235),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        DateFormat('dd/MM/yyyy').format(historyItem.date as DateTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        historyItem.attend ? 'Present' : 'Absent',
                        style: TextStyle(
                          color: historyItem.attend ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        ]
      ),
    );
  }
}
