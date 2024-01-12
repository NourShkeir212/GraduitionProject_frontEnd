class TopRatedWorkersModel {
  List<TopRatedWorkerDataModel>? data;

  TopRatedWorkersModel({this.data});

  TopRatedWorkersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TopRatedWorkerDataModel>[];
      json['data'].forEach((v) {
        data!.add(new TopRatedWorkerDataModel.fromJson(v));
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

class TopRatedWorkerDataModel {
  int? id;
  String? name;
  String? category;
  String? ratingAverage;
  int? ratingCount;
  String? profileImage;

  TopRatedWorkerDataModel(
      {this.id,
        this.name,
        this.category,
        this.ratingAverage,
        this.ratingCount,
        this.profileImage});

  TopRatedWorkerDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    ratingAverage = json['rating_average'];
    ratingCount = json['rating_count'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['rating_average'] = this.ratingAverage;
    data['rating_count'] = this.ratingCount;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
