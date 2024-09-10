class AdvanceModel {
  int? adv_trans_id ;
  String? adv_series ;
  String? adv_date;
  String? adv_party_id;
  String? adv_pay_mode;
  String? adv_pay_acc;
  String? adv_amt;
  String? adv_narration;
  String? adv_acc_date;
  String? adv_import_id;
  String? company_id;
  String? branch_id;
   int? status;

  AdvanceModel(
      {this.adv_trans_id ,
      this.adv_series ,
      this.adv_date,
      this.adv_party_id,
      this.adv_pay_mode,
      this.adv_pay_acc,
      this.adv_amt,
      this.adv_narration,
      this.adv_import_id,
      this.company_id,
      this.branch_id,
      this.adv_acc_date,
      this.status});

  AdvanceModel.fromJson(Map<String, dynamic> json) {
    adv_trans_id  = json['trans_id'];
    adv_series  = json['adv_series '];
    adv_date = json['adv_date'];
    adv_party_id = json['adv_party_id'];
    adv_pay_mode = json['adv_pay_mode'];
    adv_pay_acc = json['adv_pay_acc'];
    adv_amt = json['adv_amt'];
    adv_narration = json['adv_narration'];
    adv_import_id = json['adv_import_id'];
    company_id = json['company_id'];
    branch_id = json['branch_id'];
    adv_acc_date = json['adv_acc_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['trans_id'] = adv_trans_id ;
    data['adv_series '] = adv_series ;
    data['adv_date'] = adv_date;
    data['adv_party_id'] = adv_party_id;
    data['adv_pay_mode'] = adv_pay_mode;
    data['adv_pay_acc'] = adv_pay_acc;
    data['adv_amt'] = adv_amt;
    data['adv_narration'] = adv_narration;
    data['adv_import_id'] = adv_import_id;
    data['company_id'] = company_id;
    data['branch_id'] = branch_id;
    data['adv_acc_date'] = adv_acc_date;
    data['status'] = status;
    return data;
  }
}
