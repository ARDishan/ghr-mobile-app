import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/text_utils.dart';

class ProjectEntity extends Equatable {
  final String id; // Supabase uuid
  final int? projectBasicId; // ERP project_basicid
  final String? docId;
  final DateTime? docDate;
  final String? name;
  final String? code;
  final String? type; // e.g. "LUXURY APARTMENTS"
  final String? address;
  final String? city; // filled manually in Supabase
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status; // ERP: PENDING / COMPLETED
  final bool isActive;
  final List<String> imageUrls;
  final int? branchId;
  final String? branchPrefix; // GHR / CED
  final String? branchName;

  const ProjectEntity({
    required this.id,
    this.projectBasicId,
    this.docId,
    this.docDate,
    this.name,
    this.code,
    this.type,
    this.address,
    this.city,
    this.startDate,
    this.endDate,
    this.status,
    this.isActive = true,
    this.imageUrls = const [],
    this.branchId,
    this.branchPrefix,
    this.branchName,
  });

  static bool _blank(String? v) =>
      v == null || v.trim().isEmpty || v.trim().toUpperCase() == 'NA';

  String get displayTitle {
    if (!_blank(name)) return toTitleCase(name!);
    if (!_blank(type)) return toTitleCase(type!);
    return docId ?? 'Untitled Project';
  }

  String? get typeLabel => _blank(type) ? null : toTitleCase(type!);
  String? get cityLabel => _blank(city) ? null : toTitleCase(city!);

  bool get isCompleted => (status ?? '').trim().toUpperCase() == 'COMPLETED';

  /// The main company is GHR; anything else (e.g. Corals Edge) gets a tag.
  bool get isMainBranch =>
      branchPrefix == null || branchPrefix!.toUpperCase() == AppConstants.mainBranchPrefix;

  String? get branchLabel {
    switch ((branchPrefix ?? '').toUpperCase()) {
      case 'CED':
        return 'Corals Edge';
      case 'GHR':
        return 'GHR';
    }
    return branchName == null ? branchPrefix : toTitleCase(branchName!);
  }

  @override
  List<Object?> get props => [
        id, projectBasicId, docId, docDate, name, code, type, address, city,
        startDate, endDate, status, isActive, imageUrls, branchId, branchPrefix,
        branchName,
      ];
}
