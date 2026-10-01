import '../../domain/entities/my_unit_entity.dart';

class MyUnitModel extends MyUnitEntity {
  const MyUnitModel({
    required super.unitRefId,
    super.projectBasicId,
    super.projectName,
    super.projectCode,
    super.floor,
    super.unit,
    super.apartmentType,
    super.sqrFt,
    super.unitValue,
    super.totalScheduled,
    super.totalReceived,
    super.outstanding,
    super.overdue,
    super.defaultAmount,
  });

  static double _d(dynamic v) => (v as num?)?.toDouble() ?? 0;
  static double? _dn(dynamic v) => (v as num?)?.toDouble();

  factory MyUnitModel.fromJson(Map<String, dynamic> json) {
    return MyUnitModel(
      unitRefId: json['unit_refid'] as String,
      projectBasicId: json['project_basicid'] as int?,
      projectName: json['project_name'] as String?,
      projectCode: json['project_code'] as String?,
      floor: json['floor'] as String?,
      unit: json['unit'] as String?,
      apartmentType: json['apartment_type'] as String?,
      sqrFt: _dn(json['sqr_ft']),
      unitValue: _dn(json['unit_value']),
      totalScheduled: _d(json['total_scheduled']),
      totalReceived: _d(json['total_received']),
      outstanding: _d(json['outstanding']),
      overdue: _d(json['overdue']),
      defaultAmount: _d(json['default_amount']),
    );
  }
}