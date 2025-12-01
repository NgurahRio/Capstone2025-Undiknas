import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_website/components/BoxContent.dart';
import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/Event/CalendarEvent.dart';
import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/OpenGoogleMaps.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/components/TimePicker.dart';
import 'package:admin_website/components/WebPickerFile.dart';
import 'package:admin_website/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Event) onSave;
  final Event? existingEvent;

  const AddEvent({
    super.key,
    required this.onClose,
    required this.onSave,
    this.existingEvent,
  });

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController eventName = TextEditingController();
  TextEditingController description  = TextEditingController();
  TextEditingController startTime  = TextEditingController();
  TextEditingController endTime  = TextEditingController();
  TextEditingController mapLink  = TextEditingController();
  TextEditingController location  = TextEditingController();
  TextEditingController latitude  = TextEditingController();
  TextEditingController longitude  = TextEditingController();
  TextEditingController dos  = TextEditingController();
  TextEditingController donts  = TextEditingController();
  TextEditingController safetyGuideline = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController date = TextEditingController();

  List<Uint8List> previewImages = [];
  List<String> dosItems = [];
  List<String> dontsItems = [];
  List<String> safetyGuidelinesItems =  [];

  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  TimeOfDay parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  void initState() {
    super.initState();

    final e = widget.existingEvent;

    if (e != null) {
      eventName.text = e.name;
      description.text = e.description;
      mapLink.text = e.maps;
      location.text = e.location;
      date.text = DateFormat("dd MMMM yyyy").format(e.date);
      if (e.startTime.isNotEmpty) {
        openTime = parseTime(e.startTime);
        startTime.text = e.startTime;
      }
      if (e.endTime.isNotEmpty) {
        closeTime = parseTime(e.endTime);
        endTime.text = e.endTime;
      }
      latitude.text = e.latitude.toString();
      longitude.text = e.longitude.toString();

      dosItems = [...e.dos ?? []];
      dontsItems = [...e.donts ?? []];
      safetyGuidelinesItems = [...e.safetyGuidelines ?? []];

      price.text = formatRupiah(e.price ?? 0);

      previewImages = e.imageUrl
          .where((img) => img.length > 100) 
          .map((img) => base64Decode(img))
          .toList();
    }
  }

  Future<void> onPickImage() async {
    if (previewImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maksimal 5 foto saja!")),
      );
      return;
    }

    final result = await pickImageWeb();
    if (result == null) return;

    setState(() {
      previewImages.add(result.bytes);
    });
  }

  Future<void> onPickStartTime() async {
    final pickedOpen = await showAnalogPicker(
      context,
      initialTime: openTime,
    );

    if (pickedOpen == null) return;

    setState(() {
      openTime = pickedOpen;
      startTime.text = format24(openTime!);
    });
  }

  Future<void> onPickEndTime() async {

    final pickedClose = await showAnalogPicker(
      context,
      isClose: true,
      initialTime: closeTime,
    );

    if (pickedClose == null) return;

    setState(() {
      closeTime = pickedClose;
      endTime.text = format24(closeTime!);
    });
  }

  Widget fieldLabel ({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  void onDateSelected(DateTime? selected) {
    if (selected != null) {
      date.text = DateFormat("dd MMMM yyyy").format(selected);
    }
  }

  void removeImageSelected(int index) {
    setState(() {
      previewImages.removeAt(index);
    });
  }

  void addDoItem() {
    if (dos.text.trim().isEmpty) return;

    setState(() {
      dosItems.add(dos.text.trim());
      dos.clear();
    });
  }

  void addDontItem() {
    if (donts.text.trim().isEmpty) return;

    setState(() {
      dontsItems.add(donts.text.trim());
      donts.clear();
    });
  }

  void addSafetyGuidelineItem() {
    if (safetyGuideline.text.trim().isEmpty) return;

    setState(() {
      safetyGuidelinesItems.add(safetyGuideline.text.trim());
      safetyGuideline.clear();
    });
  }

  void deleteDoItem(int index) {
    setState(() {
      dosItems.removeAt(index);
    });
  }

  void deleteDontItem(int index) {
    setState(() {
      dontsItems.removeAt(index);
    });
  }

  void deleteSafetyGuidelineItem(int index) {
    setState(() {
      safetyGuidelinesItems.removeAt(index);
    });
  }

  void saveEvent() {
    if (eventName.text.isEmpty) return;
    if (date.text.isEmpty) return;

    final selectedDate = DateFormat("dd MMMM yyyy").parse(date.text);

    final base64Images = previewImages.map((img) => base64Encode(img)).toList();

    final rawPrice = price.text.replaceAll(RegExp(r'[^0-9]'), '');
    final priceValue = int.tryParse(rawPrice) ?? 0;

    final newEvent = Event(
      id_event: widget.existingEvent?.id_event ??
          DateTime.now().millisecondsSinceEpoch,

      name: eventName.text.trim(),
      description: description.text.trim(),

      imageUrl: base64Images,

      startTime: startTime.text.trim(),
      endTime: endTime.text.trim(),

      maps: mapLink.text.trim(),
      location: location.text.trim(),

      latitude: double.tryParse(latitude.text.trim()) ?? 0.0,
      longitude: double.tryParse(longitude.text.trim()) ?? 0.0,

      date: selectedDate,

      dos: [...dosItems],
      donts: [...dontsItems],
      safetyGuidelines: [...safetyGuidelinesItems],

      price: priceValue,
    );

    widget.onSave(newEvent);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Card(
        color: Colors.white,
        shadowColor: const Color(0x5FA6A6A6),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.existingEvent == null ? "Create Event" : "Edit Event",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                      
                    TextButton(
                      onPressed: widget.onClose, 
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.black),
                      )
                    ),
                  ],
                ),
              ),

              fieldLabel(text: "Event Galery (max 5 photo)"),

              Row(
                children: [
                  BoxImageContent(
                    images: previewImages, 
                    delete: removeImageSelected
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      icon: Icons.file_upload_outlined, 
                      text: "upload", 
                      onTap: onPickImage
                    ),
                  ),
                ],
              ),

              fieldLabel(text: "Event Time"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      width: 320,
                      child: CalenderStyle(
                        onDateSelected: onDateSelected
                      ),
                    ),
                  ),

                  Expanded(
                    child: TextFieldCostum(
                      controller: date, 
                      text: "write date event"
                    ),
                  )
                ],
              ),

              fieldLabel(text: "Event Name"),

              TextFieldCostum(
                controller: eventName, 
                text: "write event name"
              ),

              fieldLabel(text: "Description (max 100 words)"),

              TextFieldCostum(
                controller: description, 
                text: "write short description about the event"
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        fieldLabel(text: "Start Time Event"),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldCostum(
                                controller: startTime, 
                                text: "write start time event"
                              ),
                            ),
                        
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ButtonCostum3(
                                text: "clock", 
                                icon: Icons.access_time, 
                                onTap: onPickStartTime
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Text(
                      "_"
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fieldLabel(text: "End Time Event"),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldCostum(
                                controller: endTime, 
                                text: "write end time event"
                              ),
                            ),
                        
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ButtonCostum3(
                                text: "clock", 
                                icon: Icons.access_time, 
                                onTap: onPickEndTime
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              fieldLabel(text: "Map Link"),

              Row(
                children: [
                  Expanded(
                    child: TextFieldCostum(
                      controller: mapLink, 
                      text: "write the destination map link"
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      icon: Icons.map_outlined, 
                      text: "Gmaps", 
                      onTap: () {
                        OpenMap.openGoogleMaps(mapLink.text);
                      }
                    ),
                  )
                ],
              ),

              fieldLabel(text: "Location"),

              TextFieldCostum(
                controller: location, 
                text: "Enter location or address"
              ),

              fieldLabel(text: "Latitude"),
              
              TextFieldCostum(
                controller: latitude, 
                text: "write latitude destination"
              ),

              fieldLabel(text: "Longitude"),

              TextFieldCostum(
                controller: longitude, 
                text: "write longitude destination"
              ),


              fieldLabel(text: "Do & Don't"),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: dos,
                        text: "write do items",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addDoItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(dosItems.isNotEmpty)
                BoxAddContent(
                  items: dosItems, 
                  delete: deleteDoItem
                ),

              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: donts,
                        text: "write don't items",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addDontItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(dontsItems.isNotEmpty)
                BoxAddContent(
                  items: dontsItems, 
                  delete: deleteDontItem
                ),

              fieldLabel(text: "Safety Guidelines"),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: safetyGuideline,
                        text: "write safety guidelines",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addSafetyGuidelineItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(safetyGuidelinesItems.isNotEmpty)
                BoxAddContent(
                  items: safetyGuidelinesItems, 
                  delete: deleteSafetyGuidelineItem
                ),

              fieldLabel(text: "Price"),
              PriceField(
                controller: price,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingEvent == null ? "Save Event" : "Update Event" ,
                  onPressed: saveEvent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}