class ReviewsModel {
  String? ratingAverage;
  List<ReviewsDataModel>? data;

  ReviewsModel({this.ratingAverage, this.data});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    ratingAverage = json['rating_average'];
    if (json['data'] != null) {
      data = <ReviewsDataModel>[];
      json['data'].forEach((v) {
        data!.add(new ReviewsDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_average'] = this.ratingAverage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewsDataModel {
  int? id;
  Reviews? reviews;

  ReviewsDataModel({this.id, this.reviews});

  ReviewsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviews =
    json['reviews'] != null ? new Reviews.fromJson(json['reviews']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.toJson();
    }
    return data;
  }
}

class Reviews {
  String? comment;
  int? rate;
  String? date;
  User? user;

  Reviews({this.comment, this.rate, this.date, this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    rate = json['rate'];
    date = json['date'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['rate'] = this.rate;
    data['date'] = this.date;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? profileImage;

  User({this.id, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
