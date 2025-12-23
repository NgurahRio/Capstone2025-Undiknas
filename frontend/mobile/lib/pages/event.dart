import 'package:flutter/material.dart';
import 'package:mobile/componen/FormateDate.dart';
import 'package:mobile/componen/calenderStyle.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/detail.dart';

class EventPage extends StatefulWidget {
  final User? currentUser;

  const EventPage({
    super.key,
    required this.currentUser
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  DateTime? _selectedDate;
  List<Event> events = [];

  Future<void> loadEvents() async {
    try {
      final data = await getEvents();
      setState(() {
        events = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Event> get _filteredData {
    if (_selectedDate == null) return events;

    final selected = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    return events.where((item) {
      try {
        final start = DateTime.parse(item.startDate);
        final end = item.endDate != null
            ? DateTime.parse(item.endDate!)
            : start;

        final startOnly = DateTime(start.year, start.month, start.day);
        final endOnly = DateTime(end.year, end.month, end.day);

        return !selected.isBefore(startOnly) &&
              !selected.isAfter(endOnly);
      } catch (_) {
        return false;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadEvents();
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredEvent = _filteredData;

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Header(title: "Event",)
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 85),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: CalenderStyle(
                    onDateSelected: (date) {
                      setState (() => _selectedDate = date);
                    },
                  ),
                ),
            
                filteredEvent.isEmpty 
                  ? const Text("Tidak ada event pada tanggal ini")
                  : Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.345,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(14, 150, 203, 252),
                            blurRadius: 4,
                            offset: Offset(0, -10),
                          ),
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child:Row(
                              children: [
                                Text("| ", style: TextStyle(color: Color(0xFF6189af), fontSize: 21)),
                                
                                Text(
                                  "Available Events", 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  )
                                ),
                              ],
                            ),
                          ),
                  
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                            ), 
                            itemCount: filteredEvent.length,
                            itemBuilder: (context, index) {
                              final item = filteredEvent[index];
                              return CardItems1(
                                title: item.name,
                                subtitle: formatEventDate(item.startDate, item.endDate),
                                image: item.imageUrl.first,
                                onTap: () {
                                  Navigator.push(
                                    context,  
                                    MaterialPageRoute(builder: (context) => DetailPage(
                                      destination: null, 
                                      event: item,
                                      currentUser: widget.currentUser!,
                                    )),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        )
      ),
    );
  }
}