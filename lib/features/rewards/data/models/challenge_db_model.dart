import '../../../../core/util/common_utils.dart';

class ChallengeDbModel {
  const ChallengeDbModel({
    this.id = 0,
    this.title = '',
    this.current = 0,
    this.target = 0,
    this.image = '',
  });
  final int id, current, target;
  final String title, image;

  factory ChallengeDbModel.fromMap(Map<String, dynamic> json) {
    return ChallengeDbModel(
      id: CommonUtil.safeInt(json['id']),
      title: CommonUtil.safeString(json['title']),
      current: CommonUtil.safeInt(json['current']),
      target: CommonUtil.safeInt(json['target']),
      image: CommonUtil.safeString(json['image']),
    );
  }

  Map<String, dynamic> toDomainMap() => {
        'id': id,
        'title': title,
        'current': current,
        'target': target,
        'image': image,
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'current': current,
        'target': target,
        'image': image,
      };
}
