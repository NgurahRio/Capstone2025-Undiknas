import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/Event/AddEvent.dart';
import 'package:admin_website/components/Event/CalendarEvent.dart';
import 'package:admin_website/components/Event/DetailEvent.dart';
import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/event_model.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController searchEvent = TextEditingController();

  bool openAddEvent = false;

  Event? editingEvent;
  List<Event> eventSearch = [];
  List<Event> events = [];
  bool isLoading = true;

  Future<void> loadEvents() async {
    try {
      final data = await getEvents();
      setState(() {
        events = data;
        eventSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchEvent.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        eventSearch = events;
      } else {
        eventSearch = events.where((evt) {
          return evt.name.toLowerCase().contains(query) ||
                evt.startDate.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadEvents();
    searchEvent.addListener(_searchFunction);
  }

  void removeEvent(int id) {
    showPopUpDelete(
      context: context, 
      text: "Event", 
      onDelete: () async {
        try {
          await deleteEvent(id);
          setState(() {
            events.removeWhere((item) => item.id_event == id);
            searchEvent.clear();
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Event deleted successfully"),
            ),
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                HeaderCostum(controller: searchEvent),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Events",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add Event", 
                        onPressed: () {
                          setState(() {
                            openAddEvent = true;
                          });
                        }
                      )
                    ],
                  ),
                ),

                if(openAddEvent)
                  AddEvent(
                    existingEvent: editingEvent,
                    onClose: () {
                      setState(() {
                        openAddEvent = false;
                        editingEvent = null;
                      });
                    }, 
                    onSave: (updatedEvent) {
                      setState(() {
                        if(editingEvent == null) {
                          events.add(updatedEvent);
                        } else {
                          final index = events.indexWhere(
                            (e) => e.id_event == updatedEvent.id_event
                          );
                          events[index] = updatedEvent;
                        }
                      });
                    },
                  ),

                CardCostum(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "Name", flex: 2,),
                            TableHeader(title: "Date", flex: 2,),
                            TableHeader(title: "Location", flex: 2,),
                            TableHeader(title: "Price"),
                            TableHeader(title: "Actions", flex: 2,),
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...eventSearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final evt = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color(0xFFEDF6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: evt.name, flex: 2,),
                                TableContent(
                                  title: isValidEndDate(evt.endDate)
                                      ? "${formatDateDisplay(evt.startDate)} - ${formatDateDisplay(evt.endDate!)}"
                                      : formatDateDisplay(evt.startDate),
                                  flex: 2,
                                ),
                                TableContent(
                                  title: evt.location == " "
                                      ? evt.destinationId!.location
                                      : evt.location, 
                                  flex: 2,
                                ),
                                TableContent(
                                  title: evt.price != 0 ? formatRupiah(evt.price ?? 0) : "Free Entry"
                                ),
                            
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        label: "View Detail", 
                                        onTap: () => showDetailEvent(context, evt.id_event),
                                      ),
                                      Actionbutton(
                                        label: "Edit", 
                                        onTap: () {
                                          setState(() {
                                            openAddEvent = true;
                                            editingEvent = evt;
                                          });
                                        }
                                      ),
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => removeEvent(evt.id_event), 
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                )

              ],
            ),
          ),
        )
      ),
    );
  }
}