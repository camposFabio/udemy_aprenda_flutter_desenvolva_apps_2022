import 'package:flutter/material.dart';
import 'package:meals/components/main_drawer.dart';
import 'package:meals/models/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key, required this.onSettingsChange, required this.settings});

  final void Function(Settings) onSettingsChange;
  final Settings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Settings settings;

  @override
  void initState() {
    super.initState();
    settings = widget.settings;
  }

  Widget _createSwitch({
    required String title,
    String? subtitle,
    bool value = false,
    required void Function(bool) onChange,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      value: value,
      onChanged: (value) {
        onChange(value);
        widget.onSettingsChange(settings);
      },
      activeColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Configurações',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _createSwitch(
                    title: 'Sem Glúten',
                    subtitle: 'Só exibe refeições sem glúten!',
                    value: settings.isGlutenFree,
                    onChange: (value) =>
                        setState(() => settings.isGlutenFree = value),
                  ),
                  _createSwitch(
                    title: 'Sem Lactose',
                    subtitle: 'Só exibe refeições sem lactose!',
                    value: settings.isLactoseFree,
                    onChange: (value) =>
                        setState(() => settings.isLactoseFree = value),
                  ),
                  _createSwitch(
                    title: 'Vegana',
                    subtitle: 'Só exibe refeições veganas!',
                    value: settings.isVegan,
                    onChange: (value) =>
                        setState(() => settings.isVegan = value),
                  ),
                  _createSwitch(
                    title: 'Vegetariana',
                    subtitle: 'Só exibe refeições vegetarianas!',
                    value: settings.isVegetarian,
                    onChange: (value) =>
                        setState(() => settings.isVegetarian = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}
