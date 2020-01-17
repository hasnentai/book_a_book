import 'dart:async';
import 'dart:convert';

import 'package:book_a_book/modal/productmodel.dart';
import 'package:book_a_book/modal/reviews.dart';
import 'package:http/http.dart' as http;

class ProductService {
  List<ProductModel> products = List<ProductModel>();
  List<Review> reviews;
  Future<List<ProductModel>> getAllProducts() async {
    var client = new http.Client();

    var completer = new Completer<List<ProductModel>>();
    try {
      var response = await client.get(
          'https://easyaccountz.com/wp/wp-json/wc/v3/products?consumer_key=ck_bfa93e17af86e89b53ce162b1403b9ac49ca039d&consumer_secret=cs_14b596e385f7390dc649cc067effe489ed456647&page=1&order=asc&filter[meta_key]=total_sales&per_page=100');
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

 

}