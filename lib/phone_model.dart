class PhoneModel {
  int id;
  String manufacturer;
  String model;
  String androidVerion;
  String page;

  PhoneModel(
      this.id, this.manufacturer, this.model, this.androidVerion, this.page);

  PhoneModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        manufacturer = json['manufacturer'],
        model = json['model'],
        androidVerion = json['androidVerion'],
        page = json['page'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'manufacturer': manufacturer,
        'model': model,
        'androidVerion': androidVerion,
        'page': page,
      };
}
