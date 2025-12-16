import 'dart:convert';
import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/OpenGoogleMaps.dart';
import 'package:admin_website/models/event_model.dart';
import 'package:flutter/material.dart';

Widget boxType ({
  required String text,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF8AC4FA),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget labelContent ({
  required String text,
  double? paddingTop,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10, top: paddingTop ?? 20),
    child: Text(
      text, 
      style: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        color: Colors.black
      )
    ),
  );
}

Widget cardContent ({
  required String title,
  String? text,
  Widget? content,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Card(
      color: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.black54,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelContent(
              text: title,
              paddingTop: 0
            ),

            if (content != null)
              content
            else
              Text(
                text ?? "",
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

void showDetailEvent(
  BuildContext context,
  int id
  ) {
  final evt = events.firstWhere(
    (d) => d.id_event == id,
    orElse: () => throw Exception("Event not found"),
  );

  bool isBase64(String data) {
    return data.length > 200 || data.startsWith("iVBOR") || data.contains("data:image");
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: evt.imageUrl.length,
                          itemBuilder: (context, index) {
                            final image = evt.imageUrl[index];
              
                            return Image(
                              image: isBase64(image)
                                ? MemoryImage(base64Decode(image)) as ImageProvider
                                : NetworkImage(image),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                evt.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red, size: 18
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    evt.location,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 15),
                              child: Text(
                                evt.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 124, 124, 124), fontWeight: FontWeight.w300),
                              ),
                            ),

                            if(evt.price != null)
                              cardContent(
                                title: "Ticket Price", 
                                text: evt.price !=  0 ? "IDR. ${formatRupiah(evt.price!)}" : "Free Entry",
                              ),


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: cardContent(
                                    title: "Event Date", 
                                    text: evt.endDate != null 
                                      ? "${evt.startDate} - ${evt.endDate}" 
                                      : evt.startDate,
                                  ),
                                ),
                                Expanded(
                                  child: cardContent(
                                    title: "Start Time - End TIme", 
                                    text: "${evt.startTime} - ${evt.endTime}",
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: cardContent(
                                    title: "Map Link", 
                                    text: evt.maps
                                  ),
                                ),

                                cardContent(
                                  title: "(latitude, longitude)", 
                                  text: "${evt.latitude}, ${evt.longitude}",
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  OpenMap.openGoogleMaps(evt.maps);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 220, 220, 220),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Text(
                                    textAlign: TextAlign.center,
                                    "View on Google Maps",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (evt.dos != null && evt.dos!.isNotEmpty || evt.donts != null && evt.donts!.isNotEmpty)
                                  Expanded(
                                    child: cardContent(
                                      title: "Do & Don't",
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(evt.dos!.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 3),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check_box, color: Colors.green),
                                                  Text("Dos"),
                                                ],
                                              ),
                                            ),
                                            ...evt.dos!.map(
                                              (dos) => Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  dos,
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            )
                                          ],
                                    
                                          if(evt.donts!.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 3),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.close, color: Color(0xFFFF8484)),
                                                  Text("Don'ts"),
                                                ],
                                              ),
                                            ),
                                            ...evt.donts!.map(
                                              (dont) => Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  dont,
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    ),
                                  ),

                                if (evt.safetyGuidelines != null && evt.safetyGuidelines!.isNotEmpty)
                                  cardContent(
                                    title: "Safety Guidelines",
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...evt.safetyGuidelines!.map(
                                            (safety) => Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                safety,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          )
                                      ],
                                    )
                                  ),
                              ],
                            ),     
                          ],
                        ),
                      ),
              
              
                    ],
                  ),
              
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
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