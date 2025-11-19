import 'package:admin_website/components/ButtonCostum.dart';
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

  Widget _headerShowDialog(BuildContext dialogContext, {required title}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(
            title, 
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
            Navigator.of(dialogContext).pop();
          },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xFFFF8484)),
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.close,
                size: 17,
                color: const Color(0xFFFF8484),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _pickMonth() async {
    final picked = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerShowDialog(dialogContext, title: "Choose Month"),
            Divider(thickness: 2, color: Colors.black,),
          ],
        ),
        content: SizedBox(
          width: 150,
          height: 300,
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
                    fontSize: 12
                  ),
                ),
                tileColor: isSelected ? const Color(0xFF8AC4FA) : null,
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
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: _headerShowDialog(dialogContext, title: "Choose Year"),
        content: SizedBox(
          width: 250,
          height: 250,
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontSize: 12), 
                bodyLarge: TextStyle(fontSize: 12),
              ),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF8AC4FA),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: Card(
            color: Colors.white,
            shadowColor: const Color(0x5FA6A6A6),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            elevation: 10,
            child: TableCalendar(
              focusedDay: _focusedDay,
              rowHeight: 35,
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onPageChanged: (focused) => setState(() => _focusedDay = focused),
              calendarStyle: const CalendarStyle(
                cellPadding: EdgeInsets.all(5),
                markerMargin: EdgeInsets.zero,
                isTodayHighlighted: false,
                weekendTextStyle: TextStyle(fontSize: 10),
                defaultTextStyle: TextStyle(fontSize:10),
                selectedTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF8AC4FA),
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  final locale = Localizations.localeOf(context).toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: _pickMonth,
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat.MMMM(locale).format(day),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: InkWell(
                                onTap: _pickYear,
                                child: Row(
                                  children: [
                                    Text(
                                      '${day.year}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left, size: 17,),
                              onPressed: () {
                                setState(() {
                                  _focusedDay = DateTime(
                                    _focusedDay.year,
                                    _focusedDay.month - 1,
                                    1,
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, size: 17,),
                              onPressed: () {
                                setState(() {
                                  _focusedDay = DateTime(
                                    _focusedDay.year,
                                    _focusedDay.month + 1,
                                    1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                    
                      ],
                    ),
                  );
                },
                dowBuilder: (context, day) {
                  final locale = Localizations.localeOf(context).toString();
                  final text = DateFormat.E(locale).format(day);

                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ButtonCostum2(
            text: "Save date", 
            onPressed: () {
              if (_selectedDay != null) {
                widget.onDateSelected(_selectedDay);
              }
            }
          ),
        )
      ],
    );
  }
}
