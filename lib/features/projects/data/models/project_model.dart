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
    super.startDate,
    super.endDate,
    super.isActive,
    super.imageUrls,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      projectBasicId: json['project_basicid'] as int?,
      docId: json['docid'] as String?,
      docDate: json['docdate'] == null
          ? null
          : DateTime.tryParse(json['docdate'] as String),
      name: json['proj_name'] as String?,
      code: json['proj_code'] as String?,
      type: json['proj_type'] as String?,
      address: json['address'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.tryParse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.tryParse(json['end_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}