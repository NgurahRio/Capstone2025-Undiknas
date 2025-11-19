import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/Event/AddEvent.dart';
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

  void _searchFunction() {
    String query = searchEvent.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        eventSearch = events;
      } else {
        eventSearch = events.where((evt) {
          return evt.name.toLowerCase().contains(query) ||
                evt.formattedDate.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    eventSearch = events;
    searchEvent.addListener(_searchFunction);
  }

  void deleteEvent(int id) {
    showPopUpDelete(
      context: context, 
      text: "Event", 
      onDelete: () {
        setState(() {
          events.removeWhere((item) => item.id_event == id);

          searchEvent.clear();
        });
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
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "Name", flex: 2,),
                            TableHeader(title: "Date"),
                            TableHeader(title: "Location", flex: 3,),
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
                                TableContent(title: evt.formattedDate),
                                TableContent(title: evt.location, flex: 3,),
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
                                        onTap: () => deleteEvent(evt.id_event), 
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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