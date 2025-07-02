// lib/view/date_picker_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerPage extends StatefulWidget {
  final DateTime initialDate;

  const DatePickerPage({super.key, required this.initialDate});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tambahkan baris ini untuk memberi warna pada AppBar
        backgroundColor: Colors.deepPurple,
        title: const Text("Pilih Tanggal Peminjaman"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedDate);
            },
            child: const Text(
              "OKE",
              style: TextStyle(
                color: Colors.white, // Teks tetap putih agar kontras
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2030),
        focusedDay: _selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDate = selected;
          });
        },
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
