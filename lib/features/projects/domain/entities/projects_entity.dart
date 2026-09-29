import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id; // Supabase uuid
  final int? projectBasicId; // ERP project_basicid
  final String? docId;
  final DateTime? docDate;
  final String? name; // proj_name (often "NA" in ERP data currently)
  final String? code; // proj_code (often "NA" in ERP data currently)
  final String? type; // proj_type, e.g. "LUXURY APARTMENTS"
  final String? address;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<String> imageUrls;

  const ProjectEntity({
    required this.id,
    this.projectBasicId,
    this.docId,
    this.docDate,
    this.name,
    this.code,
    this.type,
    this.address,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.imageUrls = const [],
  });

  /// Falls back to [type] then [docId] since `name`/`code` are frequently
  /// "NA" in the current ERP data — TODO: revisit once ERP data is cleaner.
  String get displayTitle {
    if (name != null && name!.isNotEmpty && name != 'NA') return name!;
    if (type != null && type!.isNotEmpty) return type!;
    return docId ?? 'Untitled Project';
  }

  @override
  List<Object?> get props => [
        id,
        projectBasicId,
        docId,
        docDate,
        name,
        code,
        type,
        address,
        startDate,
        endDate,
        isActive,
        imageUrls,
      ];
}