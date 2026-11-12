import '../../../core/database/app_database.dart';
import '../../../core/database/table/banner_table.dart';
import '../../../core/database/table/challenge_table.dart';
import '../../../core/database/table/member_table.dart';
import '../../../core/database/table/product_table.dart';
import '../../../core/database/table/shop_table.dart';
import '../domain/catalog_repository.dart';
import 'models/banner_db_model.dart';

class LocalCatalogRepository implements CatalogRepository {
  const LocalCatalogRepository(this.database);
  final AppDatabase database;

  @override
  Future<List<Product>> products() async {
    final rows = await ProductTable.getAll();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<Member> member() async {
    final rows = await MemberTable.getAll();
    if (rows.isEmpty) throw StateError('Member record not found');
    return rows.first.toDomain();
  }

  @override
  Future<List<Map<String, dynamic>>> shops() async {
    final rows = await ShopTable.getAll();
    return rows.map((row) => row.toDomainMap()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> challenges() async {
    final rows = await ChallengeTable.getAll();
    return rows.map((row) => row.toDomainMap()).toList();
  }

  Future<List<BannerDbModel>> banners() async {
    final rows = await BannerTable.getAll();
    return rows;
  }
}
