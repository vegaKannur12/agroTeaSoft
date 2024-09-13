class TransMasterModel {
  int? tid;
  String? trans_series;
  String? trans_date;
  String? trans_route_id;
  String? trans_party_id;
  String? trans_party_name;
  String? trans_remark;
  String? trans_bag_nos;
  String? trans_bag_weights;
  String? trans_import_id;
  String? company_id;
  String? branch_id;
  String? user_session;
  String? log_user_id;
  String? log_date;
  int? status;

  TransMasterModel(
      {this.tid,
      this.trans_series,
      this.trans_date,
      this.trans_route_id,
      this.trans_party_id,
      this.trans_party_name,
      this.trans_remark,
      this.trans_bag_nos,
      this.trans_bag_weights,
      this.trans_import_id,
      this.company_id,
      this.branch_id,
      this.user_session,
      this.log_user_id,
      this.log_date,
      this.status});

  TransMasterModel.fromJson(Map<String, dynamic> json) {
    tid = json['trans_id'];
    trans_series = json['trans_series'];
    trans_date = json['trans_date'];
    trans_route_id = json['trans_route_id'];
    trans_party_id = json['trans_party_id'];
    trans_party_name = json['trans_party_name'];
    trans_remark = json['trans_remark'];
    trans_bag_nos = json['trans_bag_nos'];
    trans_bag_weights = json['trans_bag_weights'];
    trans_import_id = json['trans_import_id'];
    company_id = json['company_id'];
    branch_id = json['branch_id'];
    user_session = json['user_session'];
    log_user_id = json['log_user_id'];
    log_date = json['log_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['trans_id'] = tid;
    data['trans_series'] = trans_series;
    data['trans_date'] = trans_date;
    data['trans_route_id'] = trans_route_id;
    data['trans_party_id'] = trans_party_id;
    data['trans_party_name'] = trans_party_name;
    data['trans_remark'] = trans_remark;
    data['trans_bag_nos'] = trans_bag_nos;
    data['trans_bag_weights'] = trans_bag_weights;
    data['trans_import_id'] = trans_import_id;
    data['company_id'] = company_id;
    data['branch_id'] = branch_id;
    data['user_session'] = user_session;
    data['log_user_id'] = log_user_id;
    data['log_date'] = log_date;
    data['status'] = status;
    return data;
  }
}
