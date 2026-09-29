/// Maps a row from the Supabase `customers` table
/// (see supabase/migrations/0001_create_customers_table.sql).
class CustomerModel {
  final int? partymastid;
  final String? partyid;
  final String name;
  final String mobile;
  final String? email;
  final String? nic;
  final String? address;
  final String? city;
  final String? country;
  final bool isActive;

  const CustomerModel({
    this.partymastid,
    this.partyid,
    required this.name,
    required this.mobile,
    this.email,
    this.nic,
    this.address,
    this.city,
    this.country,
    this.isActive = true,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      partymastid: json['partymastid'] as int?,
      partyid: json['partyid'] as String?,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String?,
      nic: json['nic'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}