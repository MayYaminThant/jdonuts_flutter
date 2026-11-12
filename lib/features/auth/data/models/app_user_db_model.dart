import '../../../../core/util/common_utils.dart';

class AppUserDbModel {
  const AppUserDbModel({
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.birthDate = '',
  });
  final String phone, firstName, lastName, birthDate;

  factory AppUserDbModel.fromMap(Map<String, dynamic> json) {
    return AppUserDbModel(
      phone: CommonUtil.safeString(json['phone']),
      firstName: CommonUtil.safeString(json['first_name']),
      lastName: CommonUtil.safeString(json['last_name']),
      birthDate: CommonUtil.safeString(json['birth_date']),
    );
  }

  Map<String, Object?> toMap() => {
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
      };
}
