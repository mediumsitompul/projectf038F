class DataModel {
  String? locId;
  String? locX;
  String? locY;
  String? laundryName;
  String? address;
  String? phone;
  String? status;
  String? distance;

  DataModel.fromJson(Map<String, dynamic> json) {
    locId = json['id'].toString();
    locX = json['lat'];
    locY = json['lng'];
    laundryName = json['laundry_name'];
    address = json['address'];
    phone = json['phone'];
    status = json['status'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    return data;
  }
}

class ListDataModel {
  List<DataModel>? data;
  ListDataModel({this.data});

  ListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
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
