class RouteModel {
  int? rid;
  String? routename;
  int? status;

  RouteModel({this.rid, this.routename,this.status});

  RouteModel.fromJson(Map<String, dynamic> json) {
    rid = json['id'];
    routename = json['route'];
    status=json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = rid;
    data['route'] = routename;
    data['status']=status;
    return data;
  }
}
