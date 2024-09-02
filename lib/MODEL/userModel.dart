class UserModel {
  int? uid;
  String? name;
  String? username;
  String? password;
  int? company_id;
  int? branch_id;
 

  UserModel(
      {
        this.uid,this.name,
      this.username,
      this.password,
      this.company_id,
      this.branch_id,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    name = json['name'];
    username = json['uname'];
    password = json['password'];
    company_id = json['company_id'];
    branch_id = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = uid;
    data['name'] = name;
    data['uname'] = username;
    data['password'] = password;
    data['company_id'] = company_id;
    data['branch_id'] = branch_id;
    
    return data;
  }
}
