class Product {
  const Product(
      {this.id = '',
      this.code = '',
      this.name = '',
      this.price = 0,
      this.image = '',
      this.imageUrl = '',
      this.description = '',
      this.isNew = false,
      this.discount = 0});
  final String id, code, name, image, imageUrl, description;
  final double price;
  final bool isNew;
  final int discount;
}

class Member {
  const Member({
    this.name = '',
    this.tier = '',
    this.points = 0,
    this.pointsToGold = 0,
  });
  final String name, tier;
  final int points, pointsToGold;
}

abstract class CatalogRepository {
  Future<List<Product>> products();

  Future<Member> member();

  Future<List<Map<String, dynamic>>> challenges();

  Future<List<Map<String, dynamic>>> shops();
}
