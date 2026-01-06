import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/componen/formatImage.dart';

class CardItems1 extends StatelessWidget {
  final String image;
  final double? rating;
  final String title;
  final String subtitle;
  final List<String>? categories;
  final VoidCallback onTap;
  final bool? isBookmark;

  const CardItems1({
    super.key,
    required this.image,
    this.rating,
    required this.title,
    required this.subtitle,
    this.categories,
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
              image: formatImage(image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: rating == null || rating! <= 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
            children: [

              if (rating != null && rating! > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 12),
                        Text(rating!.toStringAsFixed(1), style: const TextStyle(fontSize: 11))
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isBookmark == true ? 20 : 15, 
                        fontWeight: FontWeight.w500, 
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1.5),
                            blurRadius: 6,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isBookmark == true ? 14 : 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1.5),
                            blurRadius: 6,
                            color: Colors.black54, 
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (categories != null && categories!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: categories!
                                .toSet()
                                .map((cat) => Container(
                                      width: isBookmark == true ? 70 : 65,
                                      padding: const EdgeInsets.only(left: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color.fromARGB(255, 64, 132, 196)
                                          ],
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          stops: [0.1, 0.7],
                                        ),
                                      ),
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontSize: isBookmark == true ? 12 : 11,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )
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
  final List<String>? categories;
  final String title;
  final String? location;
  final String subTitle;
  final String? clock;
  final int? price;
  final bool? isDestination;
  final VoidCallback onTap;

  CardItems2({
    super.key,
    required this.image,
    this.rating,
    this.categories,
    required this.title,
    this.location,
    this.clock,
    required this.subTitle,
    this.price,
    this.isDestination = false,
    required this.onTap,
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
                  child: Image(
                    image: formatImage(image),
                    fit: BoxFit.cover,
                    height: 130,
                    width: double.infinity,
                  ),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: rating == null || rating! <= 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                        children: [
                          if (rating != null && rating! > 0)
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow, size: 15),
                                Text(rating!.toStringAsFixed(1), style: const TextStyle(fontSize: 12))
                              ],
                            ),
                      
                          if (categories != null && categories!.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              children: categories!
                                  .toSet()
                                  .map((cat) => Container(
                                        padding: const EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color.fromARGB(255, 64, 132, 196)
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            stops: [0.1, 0.7],
                                          ),
                                        ),
                                        child: Text(
                                          cat,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
      
          
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
      
                    if(location != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined,  color: Color(0xff8ac4fa), size: 14),
                        
                            Expanded(
                              child: Text(
                                location!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF868686), 
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
      
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if(isDestination != true)
                          Icon(Icons.calendar_month, color: Color(0xff8ac4fa), size: 14),

                        Text(
                          subTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDestination == true ? Color(0xFF868686) : Colors.black,
                            fontSize: 11,
                            fontStyle: isDestination == true ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),

                    if (isDestination != true && clock != null && clock!.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(Icons.access_time, color: Color(0xff8ac4fa), size: 14),
                          Text(
                            clock!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF868686),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 45,
                  width: 110,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
