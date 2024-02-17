import 'package:flutter/material.dart';
import 'package:spark/data/subject_details.dart';
import 'package:spark/database/subject_db.dart';


class History extends StatelessWidget{
  final Subject item;
  const History({super.key, required this.item});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold)
        )),
        centerTitle: true,
      ),
      body: HistoryList(item:item),
    );
  }
}

class HistoryList extends StatefulWidget{
  final Subject item;
  
  const HistoryList({super.key,required this.item});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<HistoryList>{

  late Subject item;

  late Future<List<AttendanceCount>>? items;
  final subjectDB=SubjectDB();

  @override
  void initState(){
    super.initState();
    item=widget.item;
    fetchList(item.subName);
  }

  void fetchList(String subName){
    items=subjectDB.fetchHistory(subName);
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return layout();
  }

  Scaffold layout(){
    return Scaffold(
      body: FutureBuilder<List<AttendanceCount>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No history available for ${item.subName}'),
          );
        } else {
          List<AttendanceCount> historyList = snapshot.data!;
          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              AttendanceCount historyItem = historyList[index];
              // Customize the widget based on your data and UI requirements
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),// Add vertical padding
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 151, 27, 235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10),),),
                  title: Text(historyItem.date),
                  trailing: Text(historyItem.attend ? 'Present' : 'Absent'),
                ),
              );
            },
          );
        }
      },
    ),
    );
  }
}