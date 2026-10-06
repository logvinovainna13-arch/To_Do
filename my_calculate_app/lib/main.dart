import 'package:flutter/material.dart';
import 'app_database.dart';

const Color tiffanyColor = Color(0xFF0ABAB5);
const Color tiffanyLight = Color(0xFFE0F7F6);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiffany Calculator',
      theme: ThemeData(
        primaryColor: tiffanyColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: tiffanyColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: tiffanyColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  String _result = '0';

  void _calculate(String operation) async {
    double? num1 = double.tryParse(_num1Controller.text);
    double? num2 = double.tryParse(_num2Controller.text);

    if (num1 == null || num2 == null) {
      setState(() { _result = 'Введите числа'; });
      return;
    }

    double calcResult = 0;
    switch (operation) {
      case '+': calcResult = num1 + num2; break;
      case '-': calcResult = num1 - num2; break;
      case '*': calcResult = num1 * num2; break;
      case '/': 
        if (num2 == 0) {
          setState(() { _result = 'Деление на 0!'; });
          return;
        }
        calcResult = num1 / num2; 
        break;
    }

    final historyText = '$num1 $operation $num2 = ${calcResult.toStringAsFixed(calcResult % 1 == 0 ? 0 : 2)}';

    setState(() {
      _result = calcResult.toStringAsFixed(calcResult % 1 == 0 ? 0 : 2);
    });

    await AppDatabase.instance.addHistory(historyText);
  }

  // Стиль для полей ввода
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: tiffanyColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tiffanyColor.withOpacity(0.4), width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор Тиффани', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 28),
            onPressed: () async {
              // Ждем возврата с экрана истории, чтобы при необходимости обновить состояние
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Первое число'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _num2Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Второе число'),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _calculate('+'), child: const Text('+')),
                ElevatedButton(onPressed: () => _calculate('-'), child: const Text('-')),
                ElevatedButton(onPressed: () => _calculate('*'), child: const Text('*')),
                ElevatedButton(onPressed: () => _calculate('/'), child: const Text('/')),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tiffanyLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tiffanyColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Column(
                children: [
                  const Text('РЕЗУЛЬТАТ', style: TextStyle(color: tiffanyColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> historyList = AppDatabase.instance.getHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('История вычислений'),
        actions: [
          if (historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, size: 28),
              onPressed: () async {
                await AppDatabase.instance.clearHistory();
                setState(() {}); // Перерисовываем экран после очистки
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('История успешно очищена'), backgroundColor: tiffanyColor),
                );
              },
            ),
        ],
      ),
      body: historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_motion, size: 64, color: tiffanyColor.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  const Text('История пока пуста', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              separatorBuilder: (context, index) => const Divider(height: 20, color: tiffanyLight),
              itemBuilder: (context, index) {
                final item = historyList[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: tiffanyLight,
                    child: Icon(Icons.calculate, color: tiffanyColor),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
    );
  }
}
