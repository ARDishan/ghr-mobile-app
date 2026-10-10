import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/exceptions.dart';
import '../models/notifications_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(List<String> ids);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final supa.SupabaseClient client;
  NotificationsRemoteDataSourceImpl(this.client);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final rows = await client
          .from('notifications')
          .select('id, kind, title, body, link_url, created_at, notification_reads(notification_id)')
          .order('created_at', ascending: false)
          .limit(100);
      return (rows as List)
          .map((r) => NotificationModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(List<String> ids) async {
    if (ids.isEmpty) return;
    try {
      // user_id defaults to auth.uid() in the table; duplicates are ignored.
      await client.from('notification_reads').upsert(
            ids.map((id) => {'notification_id': id}).toList(),
            onConflict: 'notification_id,user_id',
            ignoreDuplicates: true,
          );
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}