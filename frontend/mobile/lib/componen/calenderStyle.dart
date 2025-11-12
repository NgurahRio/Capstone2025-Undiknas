import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderStyle extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  const CalenderStyle({super.key, required this.onDateSelected});

  @override
  State<CalenderStyle> createState() => _CalenderStyleState();
}

class _CalenderStyleState extends State<CalenderStyle> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Widget _headerShowDialog({required title}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(title),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.red),
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.red,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _pickMonth() async {
    final picked = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerShowDialog(title: "Choose Month"),
            Divider(thickness: 2,),
          ],
        ),
        content: SizedBox(
          width: 150,
          height: 480,
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final monthName = DateFormat.MMMM(
                Localizations.localeOf(context).toString(),
              ).format(DateTime(0, month));

              final isSelected = month == _focusedDay.month;

              return ListTile(
                minTileHeight: 20,
                title: Text(
                  monthName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                tileColor: isSelected ? const Color(0xFF6189af) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () => Navigator.pop(context, month),
              );
            },
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() => _focusedDay = DateTime(_focusedDay.year, picked, 1));
    }
  }


  Future<void> _pickYear() async {
    final picked = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: _headerShowDialog(title: "Choose Year"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF6189af),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              selectedDate: DateTime(_focusedDay.year),
              onChanged: (date) => Navigator.pop(context, date.year),
            ),
          ),
        )
      ),
    );
    if (picked != null) {
      setState(() => _focusedDay = DateTime(picked, _focusedDay.month, 1));
    }
  }

  void _clearSelectedDay() {
    setState(() {
      _selectedDay = null;
      _focusedDay = DateTime.now();
    });
    widget.onDateSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          elevation: 6,
          color: Colors.white,
          child: TableCalendar(
            focusedDay: _focusedDay,
            rowHeight: 45,
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              widget.onDateSelected(selected);
            },
            onPageChanged: (focused) => setState(() => _focusedDay = focused),
            calendarStyle: const CalendarStyle(
              todayTextStyle: TextStyle(color: Colors.black, fontSize: 16),
              weekendTextStyle: TextStyle(fontSize: 16),
              defaultTextStyle: TextStyle(fontSize:16),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(105, 43, 43, 43),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF6189af),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final locale = Localizations.localeOf(context).toString();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _pickMonth,
                      child: Row(
                        children: [
                          Text(
                            DateFormat.MMMM(locale).format(day),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: _pickYear,
                      child: Row(
                        children: [
                          Text(
                            '${day.year}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        if (_selectedDay != null)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              decoration: BoxDecoration(
                color: Color(0xffff8484),
                borderRadius: BorderRadius.circular(7),
              ),
              child: GestureDetector(
                onTap: _clearSelectedDay,
                child: const Text('Clear filter', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
      ],
    );
  }
}
