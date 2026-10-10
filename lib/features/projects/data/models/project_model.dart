import '../../domain/entities/projects_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    super.projectBasicId,
    super.docId,
    super.docDate,
    super.name,
    super.code,
    super.type,
    super.address,
    super.city,
    super.startDate,
    super.endDate,
    super.status,
    super.isActive,
    super.imageUrls,
    super.branchId,
    super.branchPrefix,
    super.branchName,
  });

  static DateTime? _date(dynamic v) =>
      v == null ? null : DateTime.tryParse(v as String);

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // `branches(...)` is embedded by the select in the data source.
    final branch = json['branches'];
    final branchMap = branch is Map<String, dynamic> ? branch : null;

    return ProjectModel(
      id: json['id'] as String,
      projectBasicId: json['project_basicid'] as int?,
      docId: json['docid'] as String?,
      docDate: _date(json['docdate']),
      name: json['proj_name'] as String?,
      code: json['proj_code'] as String?,
      type: json['proj_type'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      startDate: _date(json['start_date']),
      endDate: _date(json['end_date']),
      status: json['status'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      branchId: json['branch_id'] as int?,
      branchPrefix: branchMap?['branchprefix'] as String?,
      branchName: branchMap?['branchname'] as String?,
    );
  }
}
