import 'package:admin_website/components/ButtonCostum.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

bool isValidEndDate(String? date) {
  if (date == null || date.isEmpty) return false;

  if (date == '0000-00-00' || date == '0001-01-01') return false;

  final parsed = DateTime.tryParse(date);
  if (parsed == null) return false;

  if (parsed.year < 1900) return false;

  return true;
}

String formatDateDisplay(String isoDate) {
  final dt = DateTime.parse(isoDate);
  return DateFormat("dd MMMM yyyy").format(dt);
}

class CalenderStyle extends StatefulWidget {
  final Function(DateTime start, DateTime? end) onDateSelected;
    final DateTime? initialStart;
    final DateTime? initialEnd;

    const CalenderStyle({
      super.key,
      required this.onDateSelected,
      this.initialStart,
      this.initialEnd,
    });

  @override
  State<CalenderStyle> createState() => _CalenderStyleState();
}

class _CalenderStyleState extends State<CalenderStyle> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Widget _headerShowDialog(BuildContext dialogContext, {required title}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(
            title, 
            style: const TextStyle(
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
              child: const Icon(
                Icons.close,
                size: 17,
                color: Color(0xFFFF8484),
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
        contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerShowDialog(dialogContext, title: "Choose Month"),
            const Divider(thickness: 2, color: Colors.black,),
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
                onTap: () => Navigator.pop(dialogContext, month),
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
              onChanged: (date) {
                Navigator.pop(dialogContext, date.year);
              },
            ),
          ),
        )
      ),
    );
    if (picked != null) {
      setState(() => _focusedDay = DateTime(picked, _focusedDay.month, 1));
    }
  }

  bool _isInRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!);
  }

  @override
  void initState() {
    super.initState();

    _rangeStart = widget.initialStart;
    _rangeEnd = widget.initialEnd;

    if (_rangeStart != null) {
      _focusedDay = _rangeStart!;
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
              selectedDayPredicate: (day) {
                return isSameDay(day, _rangeStart) || isSameDay(day, _rangeEnd);
              },
              onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                }
                else if (_rangeEnd == null) {
                  if (selectedDay.isBefore(_rangeStart!)) {
                    _rangeEnd = _rangeStart;
                    _rangeStart = selectedDay;
                  } else {
                    _rangeEnd = selectedDay;
                  }
                }

                _focusedDay = focusedDay;
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
                defaultBuilder: (context, day, focusedDay) {
                  if (_isInRange(day)) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8AC4FA).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return null;
                },

                selectedBuilder: (context, day, focusedDay) {
                  final isStart = isSameDay(day, _rangeStart);
                  final isEnd = isSameDay(day, _rangeEnd);

                  if (isStart || isEnd) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8AC4FA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
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
              if (_rangeStart != null) {
                widget.onDateSelected(_rangeStart!, _rangeEnd);
              }
            },
          ),
        )
      ],
    );
  }
}
