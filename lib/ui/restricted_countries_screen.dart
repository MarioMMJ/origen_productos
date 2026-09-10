import 'package:flutter/material.dart';
import '../data/restricted_countries_repository.dart';

class RestrictedCountriesScreen extends StatefulWidget {
  const RestrictedCountriesScreen({super.key});

  @override
  State<RestrictedCountriesScreen> createState() => _RestrictedCountriesScreenState();
}

class _RestrictedCountriesScreenState extends State<RestrictedCountriesScreen> {
  final RestrictedCountriesRepository _repository = RestrictedCountriesRepository();
  final TextEditingController _controller = TextEditingController();
  List<String> _countries = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countries = await _repository.getCountries();
    if (mounted) {
      setState(() {
        _countries = countries;
      });
    }
  }

  Future<void> _addCountry() async {
    final country = _controller.text;
    if (country.trim().isNotEmpty) {
      await _repository.addCountry(country);
      _controller.clear();
      await _loadCountries();
    }
  }

  Future<void> _removeCountry(String country) async {
    await _repository.removeCountry(country);
    await _loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restricted Countries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter country name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addCountry(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCountry,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  return Card(
                    child: ListTile(
                      title: Text(country),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCountry(country),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
