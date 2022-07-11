import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    this.imageUrl =
        'https://cdn0.iconfinder.com/data/icons/marketing-214/512/Shpo.png',
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://fluttercommunication-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    try {
      var response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if(response.statusCode >= 400) {
        throw HttpException('Błąd');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
