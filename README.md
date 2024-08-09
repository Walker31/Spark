# Spark

Spark is a versatile Flutter application that allows users to manage and track events and attendance. It features a calendar system for scheduling and event management, as well as an attendance tracker for subjects or classes. The app uses the Realm database for efficient data management and ensures a seamless user experience with a well-organized UI.

## Features

### Calendar Management
- **Event Creation and Deletion**: Add, edit, and delete events or schedules categorized by type (e.g., Assignment Submission, Extra Class).
- **Real-time Event Fetching**: Dynamic fetching of events based on the selected date.
- **Filter and Search**: Filter events by categories to view specific types.

### Attendance Tracking
- **Subject Management**: Add, edit, and delete subjects/classes while tracking attendance.
- **Attendance Overview**: Display attendance summaries with percentages.
- **Search Functionality**: Search for specific attendance records.

### User Interface
- **Responsive and Intuitive Design**: User-friendly interface with custom styling.
- **Expandable Floating Action Buttons**: Quick access to add new events or subjects.

---

## Project Structure

```
lib/
|-- Pages/
|   |-- Calendar/
|   |   |-- calendar_page.dart
|   |   |-- calendar_card.dart
|   |   |-- event_list.dart
|   |   |-- events_model.dart
|   |   |-- event_manipulate.dart
|   |   |-- expandable_fab.dart
|   |   `-- time_table.dart
|   |
|   `-- Attendance/
|       |-- attendance.dart
|       |-- attendance_utils.dart
|
|-- Providers/
|   `-- attendance_provider.dart
|
|-- fonts.dart
|-- color_schemes.dart
|
`-- main.dart
```

---

## Dependencies

- **Flutter**: The framework used to build the Spark app.
- **Realm**: Database solution for data management.
- **Provider**: State management solution.
- **Intl**: For date and time formatting.
- **Logger**: For debugging and logging information.

---


- **Notification Integration**: Implement push notifications for reminders.
- **User Authentication**: Add login and authentication features.
- **Cloud Syncing**: Enable cloud storage and multi-device access.
- **Advanced Filters**: Enhance filtering and search capabilities.
- **Analytics**: Provide insights and analytics on attendance and event participation.

---
