import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';
import 'Dialogs/delete_dialog.dart';
import 'Dialogs/edit_dialog.dart';

class EventList extends StatelessWidget {
  final List<dynamic> events;
  final Realm realm;
  final void Function(String id) onDelete;
  final void Function() onEdit;

  const EventList({
    super.key,
    required this.events,
    required this.realm,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();
    logger.d('Rendering EventList with ${events.length} events');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final eventTime = event.eventTime.toLocal();
          final formattedTime = DateFormat.jm().format(eventTime);
          logger.d('Rendering event: ${event.id}, ${event.subjectName}');

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              color: Colors.blueAccent.withOpacity(0.8),
              child: Dismissible(
                key: ValueKey(event.id),
                background: Container(
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) {
                  return showDeleteDialog(context, event.id, onDelete);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent.withOpacity(0.8)),
                  child: ListTile(
                    onLongPress: () {
                      showEditDialog(context, event.id, realm, onEdit);
                    },
                    title: Text(
                      event.subjectName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black, // Match color scheme
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.eventType,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Poppins',
                            color: Colors.black87, // Match color scheme
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Poppins',
                            color: Colors.black87, // Match color scheme
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
