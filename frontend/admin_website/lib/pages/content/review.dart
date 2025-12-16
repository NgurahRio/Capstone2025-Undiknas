import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/review_model.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController searchReview = TextEditingController();

  List<Review> reviewSearch = [];
  List<Review> reviews = [];
  bool isLoading = true;

  Future<void> loadReviews() async {
    try {
      final data = await getReviews();
      setState(() {
        reviews = data;
        reviewSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchReview.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        reviewSearch = reviews;
      } else {
        reviewSearch = reviews.where((rev) {
          final user = rev.userId.username.toLowerCase();
          final destination = rev.destinationId?.name.toLowerCase() ?? "";
          final event = rev.eventId?.name.toLowerCase() ?? "";
          final type = rev.destinationId != null ? "destination" : "event";
          final rating = rev.rating.toString();

          return user.contains(query) ||
              destination.contains(query) ||
              event.contains(query) ||
              type.contains(query) ||
              rating.contains(query);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadReviews();
    searchReview.addListener(_searchFunction);
  }

  void removeReview(int id) {
    showPopUpDelete(
      context: context, 
      text: "Review", 
      onDelete: () async {
        try {
          await deleteReview(id);
          setState(() {
            reviews.removeWhere((item) => item.id_review == id);
            searchReview.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Review berhasil dihapus"),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                HeaderCostum(controller: searchReview),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Text(
                    "Manage Review",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                CardCostum(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "User"),
                            TableHeader(title: "Type"),
                            TableHeader(title: "Target", flex: 2,),
                            TableHeader(title: "Rating"),
                            TableHeader(title: "Comment", flex: 3,),
                            TableHeader(title: "Action"),
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...reviewSearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final rev = entry.value;

                        final bool isEven = index % 2 == 0;

                        final String type = rev.destinationId != null
                            ? "Destination"
                            : "Event";

                        final String target = rev.destinationId != null
                            ? rev.destinationId!.name
                            : rev.eventId!.name;

                        return Container(
                          color: isEven ? Colors.white : const Color.fromARGB(255, 237, 246, 255), // warna berbeda
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: rev.userId.username),
                                TableContent(title: type),
                                TableContent(title: target, flex: 2,),
                                TableContent(title: "${rev.rating}"),
                                TableContent(title: rev.comment, flex: 3,),

                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => removeReview(rev.id_review), 
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