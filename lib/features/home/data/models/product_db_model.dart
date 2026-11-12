import '../../../../core/util/common_utils.dart';
import '../../domain/catalog_repository.dart';

class ProductDbModel {
  const ProductDbModel(
      {this.id = '',
      this.code = '',
      this.name = '',
      this.priceMmk = 0,
      this.image = '',
      this.imageUrl = '',
      this.description = '',
      this.isNew = false,
      this.discountPercent = 0});
  final String id, code, name, image, imageUrl, description;
  final double priceMmk;
  final bool isNew;
  final int discountPercent;

  factory ProductDbModel.fromMap(Map<String, dynamic> json) {
    return ProductDbModel(
      id: CommonUtil.safeString(json['id']),
      code: CommonUtil.safeString(json['code']),
      name: CommonUtil.safeString(json['name']),
      priceMmk: CommonUtil.safeDouble(json['price_mmk']),
      image: CommonUtil.safeString(json['image']),
      imageUrl: CommonUtil.safeString(json['image_url']),
      description: CommonUtil.safeString(json['description']),
      isNew: CommonUtil.safeBool(json['is_new']),
      discountPercent: json['discount_percent'] != null
          ? CommonUtil.safeInt(json['discount_percent'])
          : 0,
    );
  }

  Product toDomain() => Product(
        id: id,
        code: code,
        name: name,
        price: priceMmk,
        image: image,
        imageUrl: imageUrl,
        description: description,
        isNew: isNew,
        discount: discountPercent,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'code': code,
        'name': name,
        'price_mmk': priceMmk,
        'image': image,
        'image_url': imageUrl,
        'description': description,
        'is_new': isNew == true ? 1 : 0,
        'discount_percent': discountPercent
      };
}
