import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/dol0026_1-.jpg",
      "assets/images/dolo_2.webp",
    ],
    title: "Dolo 650 Tablets™",
    price: 65,
    description: "Dolo 650 Tablet helps relieve pain and fever by blocking the release of certain chemical messengers responsible for fever and pain. It is used to treat headaches, migraine, toothaches, sore throats, period (menstrual) pains, arthritis, muscle aches, and the common cold.",
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/CROCIN-2.webp",
      "assets/images/crocin-650-1.webp",
    ],

    title: "Crocin 650 Tablets",
    price: 50.5,
    description: "Get effective pain relief with Crocin 650 Tablets with OPTIZORB Formulation, which provide advanced absorption",
    isPopular: true,
    isFavourite: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/azicip-500-mg-azithromycin-tablets-1.jpg",
      "assets/images/azithral_500mg_tablet_5s_48664_0_2.dib",
    ],

    title: "Azithromycin Tablets IP 500mg",
    price: 65,
    description: "Azithral 500 Tablet is an antibiotic used to treat various types of bacterial infections of the respiratory tract, ear, nose, throat, lungs, skin, and eye in adults and children. It is also effective in typhoid fever and some sexually transmitted diseases like gonorrhea.",
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/sinarest-1.webp",
      "assets/images/sinarest-2.dib",
    ],

    title: "Sinarest",
    price: 20.20,
    description: "Sinarest New Tablet is a medicine used in the treatment of common cold symptoms. It provides relief from symptoms such as headache, sore throat, runny nose, muscular pain, and fever.",
    isFavourite: true,
  ),

];