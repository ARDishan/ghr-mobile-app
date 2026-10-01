import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String name;
  final String mobile;
  final String? partyId;
  final String? whatsapp;
  final String? email;
  final String? nic;
  final String? address;
  final String? city;
  final String? country;

  const ProfileEntity({
    required this.name,
    required this.mobile,
    this.partyId,
    this.whatsapp,
    this.email,
    this.nic,
    this.address,
    this.city,
    this.country,
  });

  /// Shows only the last 4 characters of the NIC, e.g. "••••••••1234".
  String? get maskedNic {
    final v = nic?.trim();
    if (v == null || v.isEmpty) return null;
    if (v.length <= 4) return v;
    return '${'•' * (v.length - 4)}${v.substring(v.length - 4)}';
  }

  @override
  List<Object?> get props =>
      [name, mobile, partyId, whatsapp, email, nic, address, city, country];
}