class ProdModel {
  int? pid;
  String? product;

  ProdModel({this.pid, this.product});

  ProdModel.fromJson(Map<String, dynamic> json) {
    pid = json['id'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = pid;
    data['product'] = product;
    return data;
  }
}
