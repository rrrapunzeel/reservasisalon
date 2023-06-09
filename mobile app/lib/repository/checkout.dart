import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class CartRepository {
  final SupabaseClient _client;
  final SharedPreferences _prefs;

  CartRepository(this._client, this._prefs);

  Future<List<String>> loadCart(String idPerawatan) async {
    final cachedCart = _prefs.getStringList('cart_$idPerawatan');
    if (cachedCart != null) {
      return cachedCart;
    }

    final response = await _client
        .from('carts')
        .select('items')
        .eq('id_perawatan', idPerawatan)
        .execute();
    if (response.error != null) {
      throw response.error!;
    }
    final List<dynamic> items = response.data as List<dynamic>;
    final cartItems = items.map((item) => item['items'] as String).toList();
    await _prefs.setStringList('cart_$idPerawatan', cartItems);
    return cartItems;
  }
}
