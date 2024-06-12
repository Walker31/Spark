import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spark/Boxes/subject.dart';
import 'package:spark/Pages/Attendance/attendance_main.dart';
import 'package:spark/Providers/attendance_provider.dart'; // For mocking dependencies

// Mock AttendanceProvider for testing
class MockAttendanceProvider extends Mock implements AttendanceProvider {}

void main() {
  testWidgets('Attendance Page UI Test', (WidgetTester tester) async {
    // Provide a mock implementation of AttendanceProvider
    final attendanceProvider = MockAttendanceProvider();
    when(attendanceProvider.subjects).thenReturn([Subject(subName: '', subCode: '', nPresent: 0, nTotal: 0, percent: 0.0, key: 0)]);

    // Build the widget tree
    await tester.pumpWidget(
      const MaterialApp(
        home: Attendance(),
      ),
    );

    // Verify that the Attendance page is rendered correctly
    expect(find.text('Spark'), findsOneWidget); // Check for app title
    expect(find.byType(ListTile), findsWidgets); // Check for subject list
    expect(find.byIcon(Icons.add), findsOneWidget); // Check for Add button
    expect(find.byIcon(Icons.search), findsOneWidget); // Check for Search button
  });

  // Add more widget tests as needed...
}
