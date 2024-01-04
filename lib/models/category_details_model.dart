class CategoryDetailsModel {
  List<CategoryDetailsDataModel>? data;
  CategoryDetailsModel({this.data});

  CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryDetailsDataModel>[];
      json['data'].forEach((v) {
        data!.add(new CategoryDetailsDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryDetailsDataModel {
  int? id;
  String? name;
  String? bio;
  String? ratingAverage;
  int? ratingCount;
  String? availability;
  String? category;
  String? profileImage;
  bool? isFavorite;

  CategoryDetailsDataModel(
      {this.id,
        this.name,
        this.bio,
        this.ratingAverage,
        this.ratingCount,
        this.availability,
        this.category,
        this.profileImage,
        this.isFavorite});

  CategoryDetailsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bio = json['bio'];
    ratingAverage = json['rating_average'];
    ratingCount = json['rating_count'];
    availability = json['availability'];
    category = json['category'];
    profileImage = json['profile_image'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['bio'] = this.bio;
    data['rating_average'] = this.ratingAverage;
    data['rating_count'] = this.ratingCount;
    data['availability'] = this.availability;
    data['category'] = this.category;
    data['profile_image'] = this.profileImage;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
