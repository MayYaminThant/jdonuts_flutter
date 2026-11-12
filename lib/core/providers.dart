import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/auth/data/tempo_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/home/data/local_catalog_repository.dart';
import '../features/home/data/models/banner_db_model.dart';
import '../features/home/domain/catalog_repository.dart';
import 'database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  return database;
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return TempoAuthRepository(
      ref.watch(databaseProvider), ref.watch(secureStorageProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return LocalCatalogRepository(ref.watch(databaseProvider));
});

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).products();
});

final memberProvider = FutureProvider<Member>((ref) {
  return ref.watch(catalogRepositoryProvider).member();
});

final shopsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(catalogRepositoryProvider).shops();
});

final challengesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(catalogRepositoryProvider).challenges();
});

final bannersProvider = FutureProvider<List<BannerDbModel>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return (repository as LocalCatalogRepository).banners();
});
