import '../../../../core/util/common_utils.dart';
import '../../domain/catalog_repository.dart';

class MemberDbModel {
  const MemberDbModel({
    this.id = 1,
    this.name = '',
    this.tier = '',
    this.points = 0,
    this.pointsToGold = 0,
  });
  final int id;
  final String name, tier;
  final int points, pointsToGold;

  factory MemberDbModel.fromMap(Map<String, dynamic> json) {
    return MemberDbModel(
      id: CommonUtil.safeInt(json['id']),
      name: CommonUtil.safeString(json['name']),
      tier: CommonUtil.safeString(json['tier']),
      points: CommonUtil.safeInt(json['points']),
      pointsToGold: CommonUtil.safeInt(json['points_to_gold']),
    );
  }

  Member toDomain() => Member(
      name: name, tier: tier, points: points, pointsToGold: pointsToGold);

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'tier': tier,
        'points': points,
        'points_to_gold': pointsToGold
      };
}
