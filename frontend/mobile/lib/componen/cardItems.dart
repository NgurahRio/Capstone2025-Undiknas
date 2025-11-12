import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardItems1 extends StatelessWidget {
  final String image;
  final double? rating;
  final String title;
  final String subtitle;
  final String? category;
  final VoidCallback onTap;
  final bool? isBookmark;

  const CardItems1({
    super.key,
    required this.image,
    this.rating,
    required this.title,
    required this.subtitle,
    this.category,
    required this.onTap,
    this.isBookmark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 190,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: rating == null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
            children: [

              if(rating != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 12),
                        Text("${rating!.toStringAsFixed(1)}", style: TextStyle(fontSize: 11))
                      ],
                    ),
                  ),
                ),
      
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: isBookmark == true ? 20 : 15, 
                        fontWeight: FontWeight.w500, 
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1.5),
                            blurRadius: 6,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: isBookmark == true ? 14 : 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1.5),
                                  blurRadius: 6,
                                  color: Colors.black54, 
                                ),
                              ],
                            ),
                          ),
                        ) 
                      ),
      
                      if(category != null)
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: isBookmark == true ? 70 : 65,
                            padding: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.white, Color.fromARGB(255, 64, 132, 196)],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                stops: [0.1, 0.7],
                              )
                            ),
                            child: Text(
                              category!, 
                              style: TextStyle(
                                fontSize: isBookmark == true ? 12 : 11, 
                                fontWeight: FontWeight.w500, 
                                fontStyle: FontStyle.italic
                              )
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}


class CardItems2 extends StatelessWidget {
  final String image;
  final double? rating;
  final String? category;
  final String title;
  final String? location;
  final String subTitle;
  final int? price;
  final bool? isDestination;
  final VoidCallback onTap;

  CardItems2({
    super.key,
    required this.image,
    this.rating,
    this.category,
    required this.title,
    this.location,
    required this.subTitle,
    this.price,
    this.isDestination = false,
    required this.onTap
  });

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'IDR. ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    height: 130, // tinggi gambar tetap boleh
                    width: double.infinity,
                  ),
                ),
              ),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: rating == null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                        children: [
                          if(rating != null)
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 15),
                                Text(rating!.toStringAsFixed(1), style: TextStyle(fontSize: 12))
                              ],
                            ),
                      
                          if(category != null)
                            Container(
                              padding: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color.fromARGB(255, 64, 132, 196)],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  stops: [0.1, 0.7],
                                )
                              ),
                              child: Text(category!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                            ),
                        ],
                      ),
                    ),
      
          
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
      
                    if(location != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined,  color: Color(0xff8ac4fa), size: 14),
                        
                            Text(
                              location!,
                              style: TextStyle(color: const Color(0xFF868686), fontSize: 11),
                            )
                          ],
                        ),
                      ),
      
                    Text(
                      subTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: const Color(0xFF6F6F6F), fontSize: 11, fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
      
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 45,
                  width: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff8ac4fa),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)
                    )
                  ),
                  child: Text(
                    (price == null || price == 0)
                        ? isDestination == true ? "LEARN MORE" : "FREE ACCESS"
                        : currencyFormatter.format(price),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}