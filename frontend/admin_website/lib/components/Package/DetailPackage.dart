import 'dart:convert';

import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_website/components/Destination/DetailDestination.dart';

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

void showDetailPackage(
  BuildContext context,
  int id
) {
  final pac = packages.firstWhere(
    (d) => d.id_package == id,
    orElse: () => throw Exception("Package not found"),
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
        child: SizedBox(
          width: 550,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Detail Package",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => showDetailDestination(context, pac.destinationId.id_destination),
                          child: cardContent(
                            title: "Destination",
                            text: pac.destinationId.name
                          ),
                        ),
                    
                        Positioned(
                          top: 7,
                          right: 0,
                          child: Icon(Icons.ads_click, color: Color(0xFF8AC4Fa),)
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        TableHeader(title: "Package Type"),
                        TableHeader(title: "Included"),
                        TableHeader(title: "Price"),             
                      ],
                    ),
                  ),

                  const Divider(height: 1,),

                  ...pac.subPackage.asMap().entries.map((entry) {
                    final index = entry.key;
                    final type = entry.value;

                    final bool isType = index % 2 == 0;

                    final includesList = pac.includes[type.id_subPackage] ?? [];

                    final price = pac.getPrice(type.id_subPackage);

                    return Container(
                      color: isType ? Colors.white : const Color(0xFFEDF6FF),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          TableContent(
                            title: type.name,
                          ),
                      
                          TableContent(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...includesList.map(
                                  (inc) => Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        // icon
                                        isBase64 (inc["icon"]!)
                                          ? Image.memory(
                                              base64Decode(inc["icon"]!),
                                              width: 20,
                                              height: 20,
                                            )
                                          : Image.asset(  
                                              inc["icon"]!,
                                              width: 20,
                                              height: 20,
                                            ),
                      
                                        // text
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6),
                                          child: Text(
                                            inc["name"]!,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      
                          TableContent(
                            title: "IDR. ${formatRupiah(price)}",
                          ),
                        ],
                      ),
                    );
                  })

                ],
              ),
            )
          ),
        ),
      );
    }
  );
}