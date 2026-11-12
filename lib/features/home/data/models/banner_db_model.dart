import '../../../../core/util/common_utils.dart';

class BannerDbModel {
  const BannerDbModel({
    this.id = 0,
    this.image = '',
    this.sortOrder = 0,
  });
  final int id, sortOrder;
  final String image;

  factory BannerDbModel.fromMap(Map<String, dynamic> json) {
    return BannerDbModel(
      id: CommonUtil.safeInt(json['id']),
      image: CommonUtil.safeString(json['image']),
      sortOrder: CommonUtil.safeInt(json['sort_order']),
    );
  }

  Map<String, Object?> toMap() =>
      {'id': id, 'image': image, 'sort_order': sortOrder};
}
