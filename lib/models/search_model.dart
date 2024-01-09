class SearchModel {
  List<Data>? data;

  SearchModel({this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  SearchResult? searchResult;

  Data({this.searchResult});

  Data.fromJson(Map<String, dynamic> json) {
    searchResult = json['search_result'] != null
        ? new SearchResult.fromJson(json['search_result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchResult != null) {
      data['search_result'] = this.searchResult!.toJson();
    }
    return data;
  }
}

class SearchResult {
  int? id;
  String? name;
  String? profileImage;
  String? category;
  String? availability;
  String? bio;
  String? ratingAverage;
  bool? isFavorite;

  SearchResult(
      {this.id,
        this.name,
        this.profileImage,
        this.category,
        this.availability,
        this.bio,
        this.ratingAverage,
        this.isFavorite});

  SearchResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
    category = json['category'];
    availability = json['availability'];
    bio = json['bio'];
    ratingAverage = json['rating_average'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['category'] = this.category;
    data['availability'] = this.availability;
    data['bio'] = this.bio;
    data['rating_average'] = this.ratingAverage;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
