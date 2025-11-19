import 'package:intl/intl.dart';

class Event {
  final int id_event;
  final String name;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final List<String> imageUrl;
  final int? price;
  final String maps;
  final double latitude;
  final double longitude;
  final List<String>? dos;
  final List<String>? donts;
  final List<String>? safetyGuidelines;

  Event({
    required this.id_event,
    required this.name,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.imageUrl,
    this.price,
    required this.maps,
    required this.latitude,
    required this.longitude,
    this.dos,
    this.donts,
    this.safetyGuidelines,
  });

  String get formattedDate => DateFormat('dd MMMM yyyy', "en_US").format(date);
}

final List<Event> events = [
  Event(
    id_event: 1,
    name: "Ubud Food Festival",
    description:
        "A celebration of culinary arts in Ubud featuring local chefs, authentic Balinese dishes, and international collaborations.",
    date: DateTime(2025, 9, 27),
    startTime: "10:00",
    endTime: "16:00",
    location: "Jl. Raya Ubud, Gianyar, Bali",
    imageUrl: [
      "https://picsum.photos/200/300?1",
      "https://picsum.photos/200/300?2",
    ],
    price: 150000,
    maps: "https://goo.gl/maps/6tVqQKiyU1M2",
    latitude: -8.5069,
    longitude: 115.2625,
    dos: [
      "Try traditional Balinese food made by local chefs.",
      "Bring reusable bottles and utensils to reduce waste.",
      "Support small local vendors."
    ],
    donts: [
      "Do not litter around food stalls.",
      "Avoid wasting food — take only what you can finish."
    ],
    safetyGuidelines: [
      "Stay hydrated and wear comfortable clothing.",
      "Follow staff instructions during crowded hours."
    ],
  ),

  Event(
    id_event: 2,
    name: "Ubud Writers & Readers Festival",
    description:
        "An international literary event where writers, thinkers, and readers gather to celebrate stories and ideas.",
    date: DateTime(2025, 10, 5),
    startTime: "09:00",
    endTime: "21:00",
    location: "Taman Baca Ubud, Gianyar, Bali",
    imageUrl: [
      "https://picsum.photos/200/300?3",
      "https://picsum.photos/200/300?4",
    ],
    price: 200000,
    maps: "https://goo.gl/maps/9r2a1bYfFzoHcK1t7",
    latitude: -8.5063,
    longitude: 115.2633,
    dos: [
      "Listen attentively during author sessions.",
      "Engage respectfully in discussions.",
      "Support local bookshops and writers."
    ],
    donts: [
      "Avoid interrupting or recording speakers without permission.",
      "Do not use flash photography inside reading venues."
    ],
    safetyGuidelines: [
      "Keep aisles clear for accessibility.",
      "Be mindful of personal belongings during crowded sessions."
    ],
  ),

  Event(
    id_event: 3,
    name: "Ubud Village Jazz Festival",
    description:
        "A lively open-air music festival showcasing international and Indonesian jazz artists in the heart of Ubud.",
    date: DateTime(2025, 8, 16),
    startTime: "05:00",
    endTime: "11:00",
    location: "Arma Museum & Resort, Ubud, Bali",
    imageUrl: [
      "https://picsum.photos/200/300?5",
      "https://picsum.photos/200/300?6",
    ],
    price: 250000,
    maps: "https://goo.gl/maps/Bn3y1o1QEYyCKxKdA",
    latitude: -8.5203,
    longitude: 115.2654,
    dos: [
      "Arrive early to get good seating near the stage.",
      "Enjoy the music and support performing artists.",
      "Respect others' enjoyment of the show."
    ],
    donts: [
      "Avoid blocking views or using selfie sticks during performances.",
      "Do not bring outside food or alcohol."
    ],
    safetyGuidelines: [
      "Bring a hat or raincoat for outdoor events.",
      "Follow instructions from security staff for crowd safety."
    ],
  ),

  Event(
    id_event: 4,
    name: "Ubud Royal Palace Cultural Show",
    description:
        "A traditional Balinese dance and music performance held in the historic Ubud Royal Palace.",
    date: DateTime(2025, 7, 20),
    startTime: "07:30",
    endTime: "18:00",
    location: "Ubud Palace, Jl. Raya Ubud No.8, Gianyar, Bali",
    imageUrl: [
      "https://picsum.photos/200/300?7",
      "https://picsum.photos/200/300?8",
    ],
    price: 100000,
    maps: "https://goo.gl/maps/8BAVMRXgfiA2",
    latitude: -8.5064,
    longitude: 115.2621,
    dos: [
      "Be seated before the performance starts.",
      "Dress modestly and respectfully.",
    ],
    donts: [
      "Do not talk or stand during performances.",
      "Avoid using camera flash inside the stage area.",
    ],
    safetyGuidelines: [
      "Follow palace staff guidance for seating and exits.",
    ],
  ),

  Event(
    id_event: 5,
    name: "Ubud Yoga & Wellness Festival",
    description:
        "A week-long celebration of yoga, meditation, and holistic wellness with workshops and retreats across Ubud.",
    date: DateTime(2025, 6, 10),
    startTime: "06:00",
    endTime: "18:00",
    location: "The Yoga Barn, Ubud, Bali",
    imageUrl: [
      "https://picsum.photos/200/300?9",
      "https://picsum.photos/200/300?10",
    ],
    price: 300000,
    maps: "https://goo.gl/maps/qcG5uRCNMFxCNbHn9",
    latitude: -8.5194,
    longitude: 115.2630,
    dos: [
      "Bring your own yoga mat and water bottle.",
      "Respect personal space during classes.",
      "Keep a positive and calm attitude throughout the event."
    ],
    donts: [
      "Do not record classes without permission.",
      "Avoid heavy meals before yoga sessions."
    ],
    safetyGuidelines: [
      "Stay hydrated and rest between sessions.",
      "Consult the instructor if you have health concerns."
    ],
  ),
];
