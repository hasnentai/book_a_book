import 'dart:async';
import 'dart:convert';

import 'package:book_a_book/modal/category.dart';
import 'package:book_a_book/modal/productmodel.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  List<Category> category;
  List<ProductModel> categoryList;
  Future<List<Category>> getCategory() async {
    var completer = new Completer<List<Category>>();
    var client = new http.Client();
    var response;
    var data;
    print("hello");
    try {
      response = await client.get(
          'http://bookabook.co.za/wp-json/wc/v3/products/categories?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&order=desc&orderby=count');
      print(response.body);

      if (response.statusCode == 200) {
        print("hello inside true");
        data = json.decode(response.body);
        var list = data as List;
        completer.complete(category =
            list.map<Category>((i) => Category.fromJson(i)).toList());
      }
    } catch (e) {
      print(e);
    }
    return completer.future;
  }

  Future<List<ProductModel>> getCategoryDetails(int id, int currentPage) async {
    var completer = new Completer<List<ProductModel>>();
    var client = new http.Client();
    var response;
    var data;
    print("hello");
    try {
      response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=$currentPage&per_page=10&category=$id&order=asc&filter[meta_key]=total_sales&status=publish');
      print(response.body);

      if (response.statusCode == 200) {
        print("hello inside true");
        data = json.decode(response.body);
        var list = data as List;
        completer.complete(categoryList =
            list.map<ProductModel>((i) => ProductModel.fromJson(i)).toList());
      }
    } catch (e) {
      print(e);
    }
    return completer.future;
  }
}
