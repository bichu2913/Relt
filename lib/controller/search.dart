// search_controller.dart
import 'dart:async'; // Import async library

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relt/model/search.dart';

class SearchController {
  final SearchModel _searchModel;
  final StreamController<List<DocumentSnapshot<Object?>>> _productsController =
      StreamController<List<DocumentSnapshot<Object?>>>();

  SearchController(this._searchModel) {
    _init();
  }

  Future<void> _init() async {
    await _searchModel.fetchProducts();
    _productsController.add(_searchModel.filteredProducts);
  }

  // Add your controller methods here...
}

