import '../../../../core/util/common_utils.dart';

class ShopDbModel {
  const ShopDbModel({
    this.id = 0,
    this.name = '',
    this.location = '',
  });
  final int id;
  final String name, location;

  factory ShopDbModel.fromMap(Map<String, dynamic> json) {
    return ShopDbModel(
      id: CommonUtil.safeInt(json['id']),
      name: CommonUtil.safeString(json['name']),
      location: CommonUtil.safeString(json['location']),
    );
  }

  Map<String, dynamic> toDomainMap() =>
      {'id': id, 'name': name, 'location': location};

  Map<String, Object?> toMap() =>
      {'id': id, 'name': name, 'location': location};
}
