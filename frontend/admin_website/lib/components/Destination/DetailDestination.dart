import 'dart:convert';
import 'package:admin_website/components/OpenGoogleMaps.dart';
import 'package:admin_website/models/destination_model.dart';
import 'package:flutter/material.dart';

Widget boxType ({
  required String text,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Color(0xFF8AC4FA),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: TextStyle(
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
      style: TextStyle(
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

void showDetailDestination(
  BuildContext context,
  int id
  ) {
  final dest = destinations.firstWhere(
    (d) => d.id_destination == id,
    orElse: () => throw Exception("Destination not found"),
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
                          itemCount: dest.imageUrl.length,
                          itemBuilder: (context, index) {
                            final image = dest.imageUrl[index];
              
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
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                dest.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red, size: 18
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    dest.location,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 15),
                              child: Text(
                                dest.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 124, 124, 124), fontWeight: FontWeight.w300),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: dest.subCategoryId
                                  .map((subc) => subc.categoryId)
                                  .toSet()
                                  .map((cat) {
                                    return boxType(text: cat.name);
                                  }).toList(),
                              ),
                            ),

                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: dest.subCategoryId.map((subc) {
                                return boxType(text: subc.name);
                              }).toList(),
                            ),

                            if (dest.facilities != null && dest.facilities!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelContent(text: "Facilitas"),

                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: dest.facilities!.map((f) {

                                      return Container(
                                        margin: const EdgeInsets.only(right: 15),
                                        child: Column(
                                          children: [
                                            isBase64 (f.icon)
                                              ? Image.memory(
                                                  base64Decode(f.icon),
                                                  width: 20,
                                                  height: 20,
                                                )
                                              : Image.asset(  
                                                  f.icon,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                            Text(
                                              f.name.replaceAll(' ', '\n'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),


                            cardContent(
                              title: "Operational Hours", 
                              text: dest.operational,
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: cardContent(
                                    title: "Map Link", 
                                    text: dest.maps
                                  ),
                                ),

                                cardContent(
                                  title: "(latitude, longitude)", 
                                  text: "${dest.latitude}, ${dest.longitude}",
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  OpenMap.openGoogleMaps(dest.maps);
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
                                Expanded(
                                  child: Column(
                                    children: [
                                  
                                    if (dest.sos != null && dest.sos!.isNotEmpty)
                                      cardContent(
                                        title: "SOS",
                                        content: Column(
                                          children: dest.sos!.map((sos) {
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              minVerticalPadding: 0,
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.add_box_outlined, color: const Color(0xFFFF8484)),
                                                      Text(sos.name),
                                                    ],
                                                  ),
                                                  Text(
                                                    sos.address,
                                                    style: TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Wrap(
                                                  spacing: 5,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Icon(Icons.phone, color: Color(0xFF8AC4FA), size: 18,),
                                                    Text(
                                                      sos.phone,
                                                      style: TextStyle(fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      if (dest.safetyGuidelines != null && dest.safetyGuidelines!.isNotEmpty)
                                        cardContent(
                                          title: "Safety Guidelines",
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ...dest.safetyGuidelines!.map(
                                                  (safety) => Padding(
                                                    padding: const EdgeInsets.only(bottom: 5),
                                                    child: Text(
                                                      safety,
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          )
                                        )
                                    ],
                                  ),
                                ),

                                if (dest.dos != null && dest.dos!.isNotEmpty || dest.donts != null && dest.donts!.isNotEmpty)
                                  Expanded(
                                    child: cardContent(
                                      title: "Do & Don't",
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(dest.dos!.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 3),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check_box, color: Colors.green),
                                                  Text("Dos"),
                                                ],
                                              ),
                                            ),
                                            ...dest.dos!.map(
                                              (dos) => Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  dos,
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            )
                                          ],
                                    
                                          if(dest.donts!.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 3),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.close, color: Color(0xFFFF8484)),
                                                  Text("Don'ts"),
                                                ],
                                              ),
                                            ),
                                            ...dest.donts!.map(
                                              (dont) => Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  dont,
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    ),
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
                      child: CircleAvatar(
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