// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Models/attendance_count.dart';
import '../../Models/subject.dart';
import '../../Providers/attendance_provider.dart';
import '../../Widgets/background.dart';

class History extends StatelessWidget {
  final Subject item;
  const History({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              "H I S T O R Y",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 15,
          ),
          body: HistoryList(item: item),
        ),
      ),
    );
  }
} // Adjust the path as per your project structure

class HistoryList extends StatefulWidget {
  final Subject item;

  const HistoryList({super.key, required this.item});

  @override
  HistoryListState createState() => HistoryListState();
}

class HistoryListState extends State<HistoryList> {
  late Future<List<AttendanceCount>> items = Future.value([]);

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchList(widget.item.subName);
  }

  void fetchList(String subName) {
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    attendanceProvider
        .fetchAttendanceForSubject(subName)
        .then((attendanceList) {
      setState(() {
        items = Future.value(attendanceList);
      });
    }).catchError((error) {
      setState(() {
        items = Future.error(error);
      });
    });
  }

  Future<void> deleteAttendance(int id) async {
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    try {
      await attendanceProvider.deleteAttendance(id);
      fetchList(widget.item.subName); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance record deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting attendance: $e')),
      );
    }
  }

  Future<bool> confirmDelete(BuildContext context, int id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Attendance'),
          content: const Text(
              'Are you sure you want to delete this attendance record?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteAttendance(id);
      return true;
    } else {
      fetchList(widget.item.subName);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AttendanceCount>>(
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
              'No history available for ${widget.item.subName}',
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
              logger.d(historyItem);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Dismissible(
                  key: ValueKey(historyItem.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await confirmDelete(context, historyItem.id!);
                  },
                  child: ListTile(
                    tileColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      DateFormat('dd/MM/yyyy').format(historyItem.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      historyItem.attend ? 'P R E S E N T' : 'A B S E N T',
                      style: TextStyle(
                        fontSize: 16,
                        color: historyItem.attend
                            ? Colors.green
                            : const Color.fromARGB(255, 156, 16, 5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
