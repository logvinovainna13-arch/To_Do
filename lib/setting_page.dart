import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;
  const SettingsPage({super.key, required this.isDarkTheme, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _isDarkTheme = widget.isDarkTheme;
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),

            body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    "Тёмная тема",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Переключить тему приложения",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isDarkTheme,
                onChanged: (value) {
                  setState(() {
                   _isDarkTheme = value;
                  });
                  saveTheme();
                  widget.onThemeChanged(value);
                  print(value);
                  
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveTheme() async {
    final preferences = await SharedPreferences.getInstance(); //достал объект настроек (файл)
    preferences.setBool('isDarkTheme', _isDarkTheme);
  }

}