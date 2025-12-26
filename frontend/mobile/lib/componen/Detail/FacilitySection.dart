import 'package:flutter/material.dart';
import 'package:mobile/models/facility_model.dart';
import 'package:mobile/componen/formatImage.dart';

class FacilitySection extends StatelessWidget {
  final List<Facility> facilities;

  const FacilitySection({
    super.key,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Facilities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: facilities.map((f) {
                  return Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Image(
                          image: formatImage(f.icon),
                          width: 30,
                          height: 30,
                          color: Colors.black,
                          gaplessPlayback: true,
                        ),
                        Text(
                          f.name.replaceAll(' ', '\n'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
      ),
    );
  }
}
