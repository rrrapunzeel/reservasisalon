import 'package:supabase/supabase.dart';

class SupabaseCredential {
  static const String apikey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU";
  static const String apiurl = "https://fuzdyyktvczvrbwrjkhe.supabase.co";

  static SupabaseClient supabaseClient = SupabaseClient(apikey, apiurl);
}
