import 'package:shared_preferences/shared_preferences.dart';

class RestrictedCountriesRepository {
  static const String _key = 'restricted_countries';

  Future<List<String>> getCountries() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    final countries = await getCountries();
    final trimmed = country.trim();
    if (trimmed.isNotEmpty && !countries.contains(trimmed)) {
      countries.add(trimmed);
      await prefs.setStringList(_key, countries);
    }
  }

  Future<void> removeCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    final countries = await getCountries();
    if (countries.remove(country)) {
      await prefs.setStringList(_key, countries);
    }
  }
}
