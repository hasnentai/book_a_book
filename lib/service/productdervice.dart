import 'dart:async';
import 'dart:convert';

import 'package:book_a_book/modal/productmodel.dart';
import 'package:book_a_book/modal/reviews.dart';
import 'package:http/http.dart' as http;

class ProductService {
  List<ProductModel> products;
  List<Review> reviews;
  Future<List<ProductModel>> getAllProducts() async {
    var client = new http.Client();

    var completer = new Completer<List<ProductModel>>();
    try {
      var response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&order=asc&filter[meta_key]=total_sales&per_page=100');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        completer.complete(products = list
            .map<ProductModel>((i) => ProductModel.fromJson(i))
            .where((data) => data.status == "publish" && data.totalSales > 1)
            .toList());
      } else {
        print('Somthing went wrong');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return completer.future;
  }

  Future<List<Review>> getAllComments(String id) async {
    var completer = new Completer<List<Review>>();
    var client = new http.Client();

    try {
      var response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products/reviews?product=$id&per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        completer.complete(reviews = list
            .map<Review>((i) => Review.fromJson(i))
            .where((i) => i.status == "approved")
            .toList());
      } else {
        print('Somthing went wrong');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return completer.future;
  }
}
