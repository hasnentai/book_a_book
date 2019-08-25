import 'package:html/parser.dart' show parse;

class ProductModel {
  int id;
  int totalSales;
  String averageRating;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  String status;
  String purchaseNote;
  String description;
  String salePrice;
  String sortDescription;
  List<Images> images;
  List<Attributes> attri;
  bool onSale;
  bool downloadable;
  bool purchasable;

  ProductModel(
      {this.id,
      this.name,
      this.stockStatus,
      this.price,
      this.images,
      this.priceHtml,
      this.totalSales,
      this.status,
      this.description,
      this.onSale,
      this.downloadable,
      this.purchasable,
      this.salePrice,
      this.purchaseNote,
      this.sortDescription,
      this.averageRating,
      this.attri});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List;
    var attributeList = json['attributes'] as List;

    List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();
    List<Attributes> newAttributesList =
        attributeList.map((i) => Attributes.fromJson(i)).toList();

    var document = parse(json['price_html']);
    var priceElement = document.getElementsByClassName("amount");
    var bookPrice;
    if (priceElement.length > 1) {
      bookPrice = priceElement[0].text + " - " + priceElement[1].text;
    } else {
      bookPrice = "N/A";
    }
    // print(priceElement[0].text + " - "+ priceElement[1].text);

    return ProductModel(
        id: json['id'],
        name: json['name'],
        stockStatus: json['stock_status'],
        price: json['price'],
        images: imagesList,
        totalSales: json['total_sales'],
        status: json['status'],
        priceHtml: bookPrice,
        description: json['description'],
        onSale: json['on_sale'],
        downloadable: json['downloadable'],
        purchasable: json['purchasable'],
        salePrice: json['sale_price'],
        sortDescription: json['short_description'],
        averageRating: json['average_rating'],
        purchaseNote: json['purchase_note'],
        attri: newAttributesList);
  }
}

class Images {
  String src;
  Images({this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(src: json['src']);
  }
}

class Attributes {
  int id;
  String name;
  List options;
  Attributes({this.id, this.name, this.options});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
        id: json['id'], name: json['name'], options: json['options']);
  }
}
