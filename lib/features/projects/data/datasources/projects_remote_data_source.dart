import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/exceptions.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final supa.SupabaseClient client;
  ProjectsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      final rows = await client
          .from('projects')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return (rows as List)
          .map((row) => ProjectModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    try {
      final row =
          await client.from('projects').select().eq('id', id).single();
      return ProjectModel.fromJson(row);
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}