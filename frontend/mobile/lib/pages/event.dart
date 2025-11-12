import 'package:flutter/material.dart';
import 'package:mobile/componen/calenderStyle.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/pages/detail.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  DateTime? _selectedDate;

  List<Event> get _filteredData {
    if (_selectedDate == null) return events;

    return events.where((item) {
      final eventDate = item.date;
      return eventDate.year == _selectedDate!.year &&
             eventDate.month == _selectedDate!.month &&
             eventDate.day == _selectedDate!.day;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredEvent = _filteredData;

    return Scaffold(
      backgroundColor: Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
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
                  ? Text("Tidak ada event pada tanggal ini")
                  : Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.345,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                            ), 
                            itemCount: filteredEvent.length,
                            itemBuilder: (context, index) {
                              final item = filteredEvent[index];
                              return CardItems1(
                                title: item.name,
                                subtitle: item.formattedDate,
                                image: item.imageUrl[0],
                                onTap: () {
                                  Navigator.push(
                                    context,  
                                    MaterialPageRoute(builder: (context) => DetailPage(
                                      destination: null, 
                                      event: item,
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