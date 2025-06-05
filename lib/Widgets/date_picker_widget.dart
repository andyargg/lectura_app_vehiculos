import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fecha seleccionada: ${selectedDate.toLocal()}'.split(' ')[0],
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20,),
        CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          onDateChanged: (date){
            setState(() {
              selectedDate = date;
            });
          },
        )
      ],
    );
  }
}