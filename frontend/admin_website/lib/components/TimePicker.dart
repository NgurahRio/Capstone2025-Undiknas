import 'package:flutter/material.dart';

Future<TimeOfDay?> showAnalogPicker(
    BuildContext context,{
    bool isClose = false,
    TimeOfDay? initialTime
  }) async {
  final TimeOfDay now = TimeOfDay.now();

  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? now,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteColor: Colors.white,
            hourMinuteTextColor: Colors.black,
            dialBackgroundColor: Colors.grey[200],
            dialHandColor: const Color(0xFF8AC4FA),
            dialTextColor: Colors.black,
            entryModeIconColor: Colors.black,
            dialTextStyle: const TextStyle(
              fontSize: 12
            )
          ),

          colorScheme: Theme.of(context).colorScheme.copyWith(
            brightness: Brightness.light,
            primary: Colors.blue,
            onSurface: Colors.black,
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.transparent),
        ),

        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          isClose ? "Close Time" : "Open Time",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  
                      child!,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

String format24(TimeOfDay time) {
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
