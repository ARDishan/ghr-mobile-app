import 'package:equatable/equatable.dart';

/// One unit owned by the logged-in customer, with its balance figures
/// (from the get_my_outstanding_summary RPC).
class MyUnitEntity extends Equatable {
  final String unitRefId;
  final int? projectBasicId;
  final String? projectName;
  final String? projectCode;
  final String? floor;
  final String? unit;
  final String? apartmentType;
  final double? sqrFt;
  final double? unitValue;
  final double totalScheduled;
  final double totalReceived;
  final double outstanding;
  final double overdue;
  final double defaultAmount;

  const MyUnitEntity({
    required this.unitRefId,
    this.projectBasicId,
    this.projectName,
    this.projectCode,
    this.floor,
    this.unit,
    this.apartmentType,
    this.sqrFt,
    this.unitValue,
    this.totalScheduled = 0,
    this.totalReceived = 0,
    this.outstanding = 0,
    this.overdue = 0,
    this.defaultAmount = 0,
  });

  bool get hasOverdue => overdue > 0;

  String get displayProject {
    final n = projectName;
    if (n != null && n.isNotEmpty && n != 'NA') return n;
    return projectCode ?? unitRefId;
  }

  String get displayUnit =>
      [floor, unit].where((e) => e != null && e.isNotEmpty).join(' · ');

  /// Share of scheduled payments already received, 0..1.
  double get paidFraction =>
      totalScheduled <= 0 ? 0 : (totalReceived / totalScheduled).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
        unitRefId, projectBasicId, projectName, projectCode, floor, unit,
        apartmentType, sqrFt, unitValue, totalScheduled, totalReceived,
        outstanding, overdue, defaultAmount,
      ];
}