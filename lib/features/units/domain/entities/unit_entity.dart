import 'package:equatable/equatable.dart';

class UnitEntity extends Equatable {
  final String id; // Supabase uuid
  final int? tblUntmtrxDtlId; // ERP detail id
  final int? tblUntmtrxHdrId; // ERP header id
  final int? projectBasicId;
  final String? docId;
  final DateTime? docDate;
  final String? floor; // resolved label, e.g. "3RD FLOOR"
  final int? noOfUnit;
  final String? unit; // resolved label, e.g. "Unit 1"
  final double? sqrFt;
  final double? price;
  final String? status; // e.g. AVAILABLE, RESERVED
  final String? apartmentType; // e.g. "3 BED ROOM UNITS"
  final String? unitRefId; // e.g. "EBR/F03/Unit 1"

  const UnitEntity({
    required this.id,
    this.tblUntmtrxDtlId,
    this.tblUntmtrxHdrId,
    this.projectBasicId,
    this.docId,
    this.docDate,
    this.floor,
    this.noOfUnit,
    this.unit,
    this.sqrFt,
    this.price,
    this.status,
    this.apartmentType,
    this.unitRefId,
  });

  bool get isAvailable => (status ?? '').toUpperCase() == 'AVAILABLE';

  @override
  List<Object?> get props => [
        id,
        tblUntmtrxDtlId,
        tblUntmtrxHdrId,
        projectBasicId,
        docId,
        docDate,
        floor,
        noOfUnit,
        unit,
        sqrFt,
        price,
        status,
        apartmentType,
        unitRefId,
      ];
}