class TransDetailModel {
  String? trans_det_mast_id;
  int? trans_det_prod_id;
  String? trans_det_col_qty;
  String? trans_det_dmg_qty;
  String? trans_det_net_qty;
  String? trans_det_unit;
  String? trans_det_rate_id;
  String? trans_det_value;
  String? trans_det_import_id;
  String? company_id;
  String? branch_id;
  String? log_user_id;
  String? user_session;
  String? log_date;
  int? status;

  TransDetailModel(
      {this.trans_det_mast_id,
      this.trans_det_prod_id,
      this.trans_det_col_qty,
      this.trans_det_dmg_qty,
      this.trans_det_net_qty,
      this.trans_det_unit,
      this.trans_det_rate_id,
      this.trans_det_value,
      this.trans_det_import_id,
      this.company_id,
      this.branch_id,
      this.log_user_id,
      this.user_session,
      this.log_date,
      this.status});

  Map<String, dynamic> toMap() {
    return {
      'trans_det_mast_id': trans_det_mast_id,
      'trans_det_prod_id': trans_det_prod_id,
      'trans_det_col_qty': trans_det_col_qty,
      'trans_det_dmg_qty': trans_det_dmg_qty,
      'trans_det_net_qty': trans_det_net_qty,
      'trans_det_unit': trans_det_unit,
      'trans_det_rate_id': trans_det_rate_id,
      'trans_det_value': trans_det_value,
      'trans_det_import_id': trans_det_import_id,
      'company_id': company_id,
      'branch_id': branch_id,
      'log_user_id': log_user_id,
      'user_session': user_session,
      'log_date': log_date,
      'status': status,
    };
  }

// Create an instance from a Map
  factory TransDetailModel.fromMap(Map<String, dynamic> map) {
    return TransDetailModel(
      trans_det_mast_id: map['trans_det_mast_id'],
      trans_det_prod_id: map['trans_det_prod_id'],
      trans_det_col_qty: map['trans_det_col_qty'],
      trans_det_dmg_qty: map['trans_det_dmg_qty'],
      trans_det_net_qty: map['trans_det_net_qty'],
      trans_det_unit: map['trans_det_unit'],
      trans_det_rate_id: map['trans_det_rate_id'],
      trans_det_value: map['trans_det_value'],
      trans_det_import_id: map['trans_det_import_id'],
      company_id: map['company_id'],
      branch_id: map['branch_id'],
      log_user_id: map['log_user_id'],
      user_session: map['user_session'],
      log_date: map['log_date'],
      status: map['status'],
    );
  }
}
