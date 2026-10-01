import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.mobile,
    super.partyId,
    super.whatsapp,
    super.email,
    super.nic,
    super.address,
    super.city,
    super.country,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      partyId: json['partyid'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      nic: json['nic'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }
}