class WorkerModel {
  String? status;
  String? message;
  WorkerDataModel? data;

  WorkerModel({this.status, this.message, this.data});

  WorkerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new WorkerDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WorkerDataModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? address;
  String? bio;
  String? startTime;
  String? endTime;
  String? category;
  String? availability;
  int? favoriteCount;
  String? ratingAverage;
  int? ratingCount;
  String? profileImage;
  bool? isFavorite;

  WorkerDataModel(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.gender,
        this.address,
        this.bio,
        this.startTime,
        this.endTime,
        this.category,
        this.availability,
        this.favoriteCount,
        this.ratingAverage,
        this.ratingCount,
        this.profileImage,
        this.isFavorite});

  WorkerDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    address = json['address'];
    bio = json['bio'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    category = json['category'];
    availability = json['availability'];
    favoriteCount = json['favorite_count'];
    ratingAverage = json['rating_average'];
    ratingCount = json['rating_count'];
    profileImage = json['profile_image'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['bio'] = this.bio;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['category'] = this.category;
    data['availability'] = this.availability;
    data['favorite_count'] = this.favoriteCount;
    data['rating_average'] = this.ratingAverage;
    data['rating_count'] = this.ratingCount;
    data['profile_image'] = this.profileImage;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
