import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: const Text("Настройки"),
        centerTitle: true,
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme ? Colors.grey[850] : Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: isDarkTheme ? Colors.grey[800] : Colors.white,
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkTheme ? Colors.amber : Colors.orange,
                ),
                title: Text(
                  "Тёмная тема",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Switch(
                  value: isDarkTheme,
                  activeColor: Colors.amber,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkTheme = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}