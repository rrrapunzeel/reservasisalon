/// Set of all the database tables in Supabase.
///
/// Used to reference valid tables when making database requests.
abstract class SupabaseTable {
  const SupabaseTable();
  String get tableName;
}

class CategorySupabaseTable implements SupabaseTable {
  const CategorySupabaseTable();

  @override
  String get tableName => "Categories";

  String get idKategori => "id_katgeori";
  String get namaKategori => "nama_kategori";
  String get createdAt => "created_at";
}
