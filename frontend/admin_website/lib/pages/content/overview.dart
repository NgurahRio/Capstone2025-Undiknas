import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/models/category_model.dart';
import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/event_model.dart';
import 'package:admin_website/models/user_model.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final overviewItems = [
      {
        "title": "Destinations",
        "value": destinations.length,
      },
      {
        "title": "Events",
        "value": events.length,
      },
      {
        "title": "Categories",
        "value": categories.length,
      },
      {
        "title": "Users active",
        "value": users.length,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                
                HeaderCostum(controller: search),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 30,
                      childAspectRatio: 5,
                    ), 
                    itemCount: overviewItems.length,
                    itemBuilder: (context, index) {
                      final item = overviewItems[index];
                  
                      return CardCostum(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${item["title"]}"),
                  
                            Text(
                              "${item["value"]}",
                              style: const TextStyle(fontSize: 40),
                            )
                          ],
                        ),
                      );
                    }
                  ),
                ),


              ],
            ),
          ),
        )
      )
    );
  }
}