class AccountMasterModel {
  int? id;
  String? acc_code;
  String? acc_name;
  int? route;
  int? status;
  String? acc_master_type;
  String? acc_ser_code;

  AccountMasterModel(
      {this.id,
      this.acc_code,
      this.acc_name,
      this.route,
      this.status,
      this.acc_master_type,
      this.acc_ser_code});

  AccountMasterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acc_code = json['acc_code'];
    acc_name = json['acc_name'];
    route = json['acc_ext_route'];
    status = json['status'];
    acc_master_type = json['acc_master_type'];
    acc_ser_code = json['acc_ser_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['acc_code'] = acc_code;
    data['acc_name'] = acc_name;
    data['acc_ext_route'] = route;
    data['status'] = status;
    data['acc_master_type'] = acc_master_type;
    data['acc_ser_code'] = acc_ser_code;
    return data;
  }
}
