import 'package:supabase_auth/models/categories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<List<Category>> getCategory() async {
    final response = await supabase.from('kategori').select().execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final kategori = data.map((json) => Category.fromJson(json)).toList();

    return kategori;
  }

  Future<List<Category>> getCategoriesByCategoryName(
      String namaKategori) async {
    final response = await supabase
        .from('kategori')
        .select('*')
        .eq('nama_kategori', namaKategori)
        .execute();

    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    final List<Category> categories = [];

    for (final categoryData in response.data ?? []) {
      final category = Category.fromMap(categoryData);
      categories.add(category);
    }

    return categories;
  }

  Future<Category?> getCategoryById(int idKategori) async {
    final response = await supabase
        .from('kategori')
        .select('*')
        .eq('id_kategori', idKategori)
        .execute();

    if (response.data.isNotEmpty) {
      return Category.fromJson(response.data[0]);
    } else {
      return null;
    }
  }
}
