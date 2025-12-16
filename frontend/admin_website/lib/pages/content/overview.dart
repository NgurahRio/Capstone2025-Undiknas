import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/layout/responsive.dart';
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

  int totalDestinations = 0;
  int totalEvents = 0;
  int totalCategories = 0;
  int totalUsers = 0;
  bool isLoading = true;


  Future<void> loadOverview() async {
    try {
      final d = await getDestinations();
      final e = await getEvents();
      final c = await getCategories();
      final u = await getUsers();

      setState(() {
        totalDestinations = d.length;
        totalEvents = e.length;
        totalCategories = c.length;
        totalUsers = u.length;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadOverview();
  }

  @override
  Widget build(BuildContext context) {

    final overviewItems = [
      {
        "title": "Destinations",
        "value": totalDestinations,
      },
      {
        "title": "Events",
        "value": totalEvents,
      },
      {
        "title": "Categories",
        "value": totalCategories,
      },
      {
        "title": "Users active",
        "value": totalUsers,
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
                
                HeaderCostum(controller: search, isSearch: false,),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isDesktop(context) ? 2 : 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 30,
                        mainAxisExtent: 100
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
                              Text(
                                "${item["title"]}",
                                style: TextStyle(fontSize: Responsive.text(context, 16)),
                              ),

                              Text(
                                "${item["value"]}",
                                style: TextStyle(fontSize: Responsive.text(context, 40)),
                              ),
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