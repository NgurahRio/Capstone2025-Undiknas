import 'dart:convert';

import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_website/components/Destination/DetailDestination.dart';

OverlayEntry? _overlayDest;
final LayerLink _destLink = LayerLink();
final GlobalKey _destKey = GlobalKey();
bool _isDropdownDest = false;

void _showDestination({
  required BuildContext context,
  required int id,
}) {
  if (_isDropdownDest && _overlayDest != null) {
    _overlayDest!.remove();
    _overlayDest = null;
    _isDropdownDest = false;
    return;
  }

  final overlay = Overlay.of(context);
  final renderBox = _destKey.currentContext!.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);

  final entry = OverlayEntry(
    builder: (context) => Positioned(
      left: offset.dx,
      width: 300,
      height: 350,
      child: CompositedTransformFollower(
        link: _destLink,
        showWhenUnlinked: false,
        offset: Offset(size.width, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(15),
            child: DetailDestination(id: id, isSmall: true,),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  _overlayDest = entry;
  _isDropdownDest = true;
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

  final imageDest = pac.destinationId.imageUrl[0];

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
          key: _destKey,
          width: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Detail Package",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
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
                        CompositedTransformTarget(
                          link: _destLink,
                          child: GestureDetector(
                            onTap: () {
                              _showDestination(
                                context: context, 
                                id: pac.destinationId.id_destination
                              );
                            },
                            child: SizedBox(
                              width: 350,
                              child: CardCostum(
                                content: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: isBase64(imageDest)
                                              ? MemoryImage(base64Decode(imageDest)) as ImageProvider
                                              : NetworkImage(imageDest)
                                          )
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 3),
                                              child: Text(
                                                pac.destinationId.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16
                                                ),
                                              ),
                                            ),
                                        
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.red, size: 12
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    pac.destinationId.location,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 11
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                        ),
                    
                        const Positioned(
                          top: 3,
                          right: 3,
                          child: Icon(Icons.ads_click, color: Color(0xFF8AC4Fa),)
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        TableHeader(title: "Package dest"),
                        TableHeader(title: "Included"),
                        TableHeader(title: "Price"),             
                      ],
                    ),
                  ),

                  const Divider(height: 1,),

                  ...pac.subPackage.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dest = entry.value;

                    final bool isdest = index % 2 == 0;

                    final includesList = pac.includes[dest.id_subPackage] ?? [];

                    final price = pac.getPrice(dest.id_subPackage);

                    return Container(
                      color: isdest ? Colors.white : const Color(0xFFEDF6FF),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          TableContent(
                            title: dest.name,
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
  ).then((_) {
    if (_overlayDest != null) {
      _overlayDest!.remove();
      _overlayDest = null;
    }

    _isDropdownDest = false;
  });
}