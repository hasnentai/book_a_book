class Review {
  int id;
  String dateCreated;
  int productId;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  int rating;
  bool verified;
  List<Avater> avaterUrl;

  Review(
      {this.rating,
      //this.avaterUrl,
      this.dateCreated,
      this.id,
      this.productId,
      this.review,
      this.reviewer,
      this.reviewerEmail,
      this.status,
      this.verified});

  factory Review.fromJson(Map<String, dynamic> json) {
    //var avaterList = json['reviewer_avatar_urls'];

    // List<Avater> finalAvaterList =
    //avaterList.map((i) => Avater.fromJson(i)).toList();
    return Review(
        id: json['id'],
        dateCreated: json['date_created'],
        productId: json['product_id'],
        status: json['status'],
        reviewer: json['reviewer'],
        review: json['review'],
        rating: json['rating'],
        verified: json['verified']
        // avaterUrl: finalAvaterList);
        );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['product_id'] = productId;
    map['review'] = review;
    map['reviewer'] = reviewer;
    map['reviewer_email'] = reviewerEmail;
    map['rating'] = rating;
  }
}

class Avater {
  String twoFour;
  String fourEight;
  String nineSix;
  Avater({this.fourEight, this.nineSix, this.twoFour});

  factory Avater.fromJson(Map<String, dynamic> json) {
    return Avater(
        twoFour: json['24'], fourEight: json['48'], nineSix: json['96']);
  }
}
