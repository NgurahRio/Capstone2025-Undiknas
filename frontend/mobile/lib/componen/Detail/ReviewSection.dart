import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/formatImage.dart';
import 'package:mobile/models/review_model.dart';
import 'package:mobile/models/user_model.dart';

Widget _ratingStars({ required double rating, bool position = true }) {
  return StarRating(
    size: 15,
    rating: rating,
    color: Colors.amber,
    borderColor: Colors.grey,
    starCount: 5,
    mainAxisAlignment: position ? MainAxisAlignment.center : MainAxisAlignment.start,
  );
}

class ReviewSection extends StatefulWidget {
  final List<Review> review;
  final double averageRating;
  final VoidCallback onSeeAll;
  final VoidCallback onWrite;

  const ReviewSection({
    super.key,
    required this.review,
    required this.averageRating,
    required this.onSeeAll,
    required this.onWrite,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F9FF),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.review.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Belum ada ulasan",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    )
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Text("Reviews",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  )
                                ),
                            
                                Positioned(
                                  right: 20,
                                  child: InkWell(
                                    onTap: widget.onSeeAll,
                                    child: const Text(
                                      "See All",
                                      style: TextStyle(color: Color(0xFF8AC4FA), fontSize: 14),
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),

                          Text(widget.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 37,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            )
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: _ratingStars(rating: widget.averageRating),
                          ),

                          Text(
                            "Based on ${widget.review.length} comments",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w300
                            )
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 20),
                      child: Divider(
                        thickness: 2,
                        color: Colors.white,
                      ),
                    ),
                    ...widget.review.map((rev) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(right: 7),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: rev.userId.image.isNotEmpty
                                ?  ClipOval(
                                    child: Image(
                                      image: formatImage(rev.userId.image),
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon( 
                                    Icons.account_circle,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(rev.userId.username,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                  
                                          if(rev.userId.id_user == User.currentUser!.id_user)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 7),
                                              child: Text(
                                                "(you)",
                                                style: const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300
                                                )
                                              ),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: _ratingStars(
                                                  rating: rev.rating,
                                                  position: false
                                                ),
                                              ),
                                  
                                              Text(
                                                rev.rating.toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ))
                                            ],
                                          ),
                                  
                                          Text(
                                            TimeOfDay.fromDateTime(rev.createdAt).format(context),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            )
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          rev.comment,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
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
                      );
                    }),
                  ],
                ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: ButtonCostum(
                text: "Write a comment", 
                onPressed: widget.onWrite,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> submitReview({
  required BuildContext context,
  int? destinationId,
  int? eventId,
  required int rating,
  required String comment,
  required VoidCallback onSuccess,
}) async {
  if ((destinationId == null && eventId == null) ||
      (destinationId != null && eventId != null)) {
    throw Exception("Target review tidak valid");
  }

  if (rating < 1 || rating > 5) {
    throw Exception("Rating harus antara 1-5");
  }

  if (comment.trim().isEmpty) {
    throw Exception("Komentar tidak boleh kosong");
  }

  try {
    await createReview(
      destinationId: destinationId,
      eventId: eventId,
      rating: rating,
      comment: comment,
    );

    onSuccess();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Review berhasil ditambahkan"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      ),
    );
    rethrow;
  }
}

void showcommentPopup(
  BuildContext context, {
  int? destinationId,
  int? eventId,
  required VoidCallback onSuccess,
  }) {
    double rating = 0.0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Write your comment",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: TextField(
                          controller: commentController,
                          maxLength: 300,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "What did you like about this trip?",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 235, 244, 251),
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            counterText: "",
                          ),
                        ),
                      ),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "300 characters letf",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Column(
                          children: [
                            const Text(
                              "Give Stars",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                        
                            StarRating(
                              rating: rating,
                              starCount: 5,
                              size: 30,
                              color: Colors.amber,
                              borderColor: Colors.amber,
                              onRatingChanged: (value) {
                                setState(() {
                                  rating = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      ButtonCostum(
                        text: "Submit comment", 
                        height: 50,
                        onPressed: () async {
                          try {
                            await submitReview(
                              context: context,
                              destinationId: destinationId,
                              eventId: eventId,
                              rating: rating.toInt(),
                              comment: commentController.text,
                              onSuccess: onSuccess,
                            );

                            if (rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please give a rating first"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
