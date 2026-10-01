import '../../domain/entities/unit_entity.dart';

class UnitModel extends UnitEntity {
  const UnitModel({
    required super.id,
    super.tblUntmtrxDtlId,
    super.tblUntmtrxHdrId,
    super.projectBasicId,
    super.docId,
    super.docDate,
    super.floor,
    super.noOfUnit,
    super.unit,
    super.sqrFt,
    super.price,
    super.status,
    super.apartmentType,
    super.unitRefId,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as String,
      tblUntmtrxDtlId: json['tbl_untmtrx_dtlid'] as int?,
      tblUntmtrxHdrId: json['tbl_untmtrx_hdrid'] as int?,
      projectBasicId: json['project_basicid'] as int?,
      docId: json['docid'] as String?,
      docDate: json['docdate'] == null
          ? null
          : DateTime.tryParse(json['docdate'] as String),
      floor: json['floor'] as String?,
      noOfUnit: json['no_of_unit'] as int?,
      unit: json['unit'] as String?,
      sqrFt: (json['sqr_ft'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      apartmentType: json['apartment_type'] as String?,
      unitRefId: json['unit_refid'] as String?,
    );
  }
}