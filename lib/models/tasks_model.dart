class TasksModel {
  String? message;
  List<TaskDataModel>? data;

  TasksModel({this.message, this.data});

  TasksModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskDataModel>[];
      json['data'].forEach((v) {
        data!.add(TaskDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskDataModel {
  int? id;
  Tasks? tasks;
  Worker? worker;

  TaskDataModel({this.id, this.tasks, this.worker});

  TaskDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tasks = json['tasks'] != null ? Tasks.fromJson(json['tasks']) : null;
    worker =
    json['worker'] != null ? Worker.fromJson(json['worker']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (tasks != null) {
      data['tasks'] = tasks!.toJson();
    }
    if (worker != null) {
      data['worker'] = worker!.toJson();
    }
    return data;
  }
}

class Tasks {
  String? date;
  String? day;
  String? startTime;
  String? endTime;
  String? description;
  String? status;
  String? completeTask;

  Tasks(
      {this.date,
        this.day,
        this.startTime,
        this.endTime,
        this.description,
        this.status,
        this.completeTask});

  Tasks.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    description = json['description'];
    status = json['status']??"";
    completeTask = json['complete_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = date;
    data['day'] = day;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['description'] = description;
    data['status'] = status;
    data['complete_task'] = completeTask;
    return data;
  }
}

class Worker {
  int? id;
  String? name;
  String? phone;
  String? profileImage;
  String? ratingAverage;
  String? address;
  String? category;

  Worker({this.id,
    this.name,
    this.phone,
    this.profileImage,
    this.ratingAverage,
    this.address,
    this.category,
  });

  Worker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    ratingAverage = json['rating_average'];
    address = json['address'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['profile_image'] = profileImage;
    data['rating_average'] = ratingAverage;
    data['address'] = address;
    data['category'] = category;
    return data;
  }
}
